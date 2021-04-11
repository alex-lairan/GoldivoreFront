component Pages.Home {
  connect Theme exposing { titleColor, secondaryColor }
  connect Stores.Api.Servers.Index exposing { status as serversStatus }
  connect Stores.Api.Raids.Index exposing { status as raidsStatus }
  connect Stores.Api.Instances.Create exposing { isReady, submit, setRaidId, setServerId, setDate }

  style base {
    display: flex;
    align-items: center;
    justify-content: space-around;
    flex-direction: column;
  }

  style title {
    color: #{titleColor};
  }

  style sub-title {
    color: #{secondaryColor};
  }

  fun handleRaidId (event : Html.Event) : a {
    setRaidId(raidId)
  } where {
    raidId = Dom.getValue(event.target) |> Number.fromString |> Maybe.withDefault(0)
  }

  fun handleServerId (event : Html.Event) : a {
    setServerId(serverId)
  } where {
    serverId = Dom.getValue(event.target) |> Number.fromString |> Maybe.withDefault(0)
  }

  fun handleDate (event : Html.Event) : a {
    setDate(date)
  } where {
    date = Dom.getValue(event.target)
  }

  get raids : Array(Html) {
    rawRaids
    |> Array.map((expansion : Aggregates.Raid.Expansion) : Html { <Molecules.Raid.Expansion expansion={expansion} /> })
  }

  get servers : Array(Html) {
    rawServers
    |> Array.map((region : Aggregates.Server.Region) : Html { <Molecules.Server.Region region={region} /> })
  }

  get rawServers : Array(Aggregates.Server.Region) {
    Api.withDefault([], serversStatus)
  }

  get rawRaids : Array(Aggregates.Raid.Expansion) {
    Api.withDefault([], raidsStatus)
  }

  fun handleServer(event : Html.Event) : Promise(Never, Void) {
    parallel { Debug.log(isReady()) }
  }

  fun render : Html {
    <div::base>
      <h1::title>"Goldovore"</h1>

      <Molecules.Container>
        <h2::sub-title>"Create Instance"</h2>

        <Molecules.Form.Select label="Raid" id="raid" onInput={handleRaidId} > <{ raids }> </Molecules.Form.Select>
        <Molecules.Form.Select label="Server" id="server" onInput={handleServerId}> <{ servers }> </Molecules.Form.Select>
        <Molecules.Form.Input label="Date" id="date" type="date" onInput={handleDate} />

        <Atoms.Button onClick={submit} disabled={isReady()}> "Create" </Atoms.Button>
      </Molecules.Container>
    </div>
  }
}

component Molecules.Server.Region {
  property region : Aggregates.Server.Region

  fun render : Html {
    <optgroup label={region.name}>
      for (server of region.servers) {
        <option value={"#{server.id}"}><{server.name}></option>
      }
    </optgroup>
  }
}

component Molecules.Raid.Expansion {
  property expansion : Aggregates.Raid.Expansion

  fun render : Html {
    <optgroup label={expansion.name}>
      for (raid of expansion.raids) {
        <option value={"#{raid.id}"}><{raid.name}></option>
      }
    </optgroup>
  }
}

component Molecules.Container {
  connect Theme exposing { containerBackground, borderRadius }

  property children : Array(Html) = []

  style base {
    background-color: #{containerBackground};
    border-radius: #{borderRadius};
    width: 50vw;

    display: flex;
    align-items: center;
    justify-content: space-around;
    flex-direction: column;
  }

  fun render : Html {
    <div::base>
      <{ children }>
    </div>
  }
}