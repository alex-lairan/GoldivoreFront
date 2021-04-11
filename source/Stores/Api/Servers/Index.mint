record Aggregates.Server.Region {
  name : String,
  servers : Array(Leaf.Server)
}

record Leaf.Server {
  name : String,
  id : Number
}

store Stores.Api.Servers.Index {
  state status : Api.Status(Array(Aggregates.Server.Region)) = Api.Status::Initial

  fun load() : Promise(Never, Void) {
    sequence {
      next { status = Api.Status::Loading }

      request = Http.get("/servers")

      newStatus = Api.send(decoder, request)

      next { status = Debug.log(newStatus) }
    }
  }

  fun decoder (object : Object) : Result(Object.Error, Array(Aggregates.Server.Region)) {
    decode object as Map(String, Array(Leaf.Server))
    |> Result.map(mapToArray)
  }

  fun mapToArray(map : Map(String, Array(Leaf.Server))) : Array(Aggregates.Server.Region) {
    map
    |> Map.reduce(
      [],
      (acc : Array(Aggregates.Server.Region), key: String, value: Array(Leaf.Server)) : Array(Aggregates.Server.Region) { 
        Array.push({ name = key, servers = value }, acc)
      }
    )
  }
}
