record Aggregates.Instance.Creation {
  raidId : Number using "raid_id",
  serverId : Number using "server_id",
  date : String
}

record Aggregates.Instance {
  id : Number,
  date : String,
  raid : Leaf.Raid,
  server : Leaf.Server
}

store Stores.Api.Instances.Create {
  state status : Api.Status(Aggregates.Instance) = Api.Status::Initial

  state raidId : Maybe(Number) = Maybe.nothing()
  state serverId : Maybe(Number) = Maybe.nothing()
  state date : Maybe(String) = Maybe.nothing()

  fun setRaidId (raidId : Number) {
    next { raidId = Maybe.just(raidId) }
  }

  fun setServerId (serverId : Number) {
    next { serverId = Maybe.just(serverId) }
  }

  fun setDate (date : String) {
    next { date = Maybe.just(date) }
  }

  fun isReady () : Bool {
    Maybe.isJust(raidId) && 
      Maybe.isJust(serverId) && 
      Maybe.isJust(date)
  }

  fun submit (event : Html.Event) : Promise(Never, Void) {
    if (isReady()) {
      sequence {
        next { status = Api.Status::Loading }

        encodedBody = encode { 
          raidId = raidId |> Maybe.withDefault(0), 
          serverId = serverId |> Maybe.withDefault(0), 
          date = date |> Maybe.withDefault("") 
        }

        request = 
          Http.post("/instances")
          |> Http.jsonBody(encodedBody)

        newStatus = Api.send(decoder, request)

        next { status = Debug.log(newStatus) }

        case (status) {
          Api.Status::Ok e => Window.navigate("/instances/#{e.id}")
          => next {}
        }
      }
    } else {
      next {}
    }
  }

  fun decoder (object : Object) : Result(Object.Error, Aggregates.Instance) {
    decode Debug.log(object) as Aggregates.Instance
  }
}
