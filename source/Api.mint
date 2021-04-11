record Api.ErrorResponse {
  errors : Map(String, Array(String))
}

module Api {
  fun toStatus (status : Api.Status(a)) : Status {
    case (status) {
      Api.Status::Loading => Status::Loading
      Api.Status::Initial => Status::Initial
      Api.Status::Error => Status::Error
      Api.Status::Ok => Status::Ok
    }
  }

  fun withDefault (a : a, status : Api.Status(a)) : a {
    case (status) {
      Api.Status::Ok value => value
      => a
    }
  }

  fun errors (status : Api.Status(a)) : Api.ErrorResponse {
    case (status) {
      Api.Status::Error error => error
      => { errors = Map.empty() }
    }
  }

  fun isLoading (status : Api.Status(a)) : Bool {
    case (status) {
      Api.Status::Loading => true
      => false
    }
  }

  fun errorStatus (key : String, value : String) : Api.Status(a) {
    Api.Status::Error({ errors = error })
  } where {
    error =
      Map.empty()
      |> Map.set(key, [value])
  }

  fun errorsOf (key : String, status : Api.Status(a)) : Array(String) {
    case (status) {
      Api.Status::Error errors =>
        errors.errors
        |> Map.get(key)
        |> Maybe.withDefault([])

      => []
    }
  }

  fun decodeErrors (body : String) : Api.Status(a) {
    try {
      object =
        Json.parse(body)
        |> Maybe.toResult("")

      errors =
        decode object as Api.ErrorResponse

      Api.Status::Error(errors)
    } catch Object.Error => error {
      errorStatus("request", "Could not decode the error response.")
    } catch String => error {
      errorStatus("request", "Could not parse the error response.")
    }
  }

  fun send (
    decoder : Function(Object, Result(Object.Error, a)),
    request : Http.Request
  ) : Promise(Never, Api.Status(a)) {
    sequence {
      response =
        { request | url = @ENDPOINT + request.url }
        |> Http.header("Content-Type", "application/json")
        |> Http.send()

      case (response.status) {
        401 => errorStatus("request", "Unauthorized!")
        403 => decodeErrors(response.body)
        422 => decodeErrors(response.body)

        =>
          try {
            object =
              Json.parse(response.body)
              |> Maybe.toResult("")

            data =
              decoder(object)

            Api.Status::Ok(data)
          } catch Object.Error => error {
            errorStatus("request", "Could not decode the response.")
          } catch String => error {
            errorStatus("request", "Could not parse the response.")
          }
      }
    } catch Http.ErrorResponse => error {
      errorStatus("request", "Network error.")
    }
  }
}
