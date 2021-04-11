record Aggregates.Raid.Expansion {
  name : String,
  raids : Array(Leaf.Raid)
}

record Leaf.Raid {
  name : String,
  id : Number
}

store Stores.Api.Raids.Index {
  state status : Api.Status(Array(Aggregates.Raid.Expansion)) = Api.Status::Initial

  fun load() : Promise(Never, Void) {
    sequence {
      next { status = Api.Status::Loading }

      request = Http.get("/raids")

      newStatus = Api.send(decoder, request)

      next { status = Debug.log(newStatus) }
    }
  }

  fun decoder (object : Object) : Result(Object.Error, Array(Aggregates.Raid.Expansion)) {
    decode object as Map(String, Array(Leaf.Raid))
    |> Result.map(mapToArray)
  }

  fun mapToArray(map : Map(String, Array(Leaf.Raid))) : Array(Aggregates.Raid.Expansion) {
    map
    |> Map.reduce(
      [],
      (acc : Array(Aggregates.Raid.Expansion), key: String, value: Array(Leaf.Raid)) : Array(Aggregates.Raid.Expansion) { 
        Array.push({ name = key, raids = value }, acc)
      }
    )
  }
}
