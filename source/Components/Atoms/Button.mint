component Atoms.Button {
  connect Theme exposing { containerBackground, titleColor, secondaryColor, textColor }

  property onClick : Function(Html.Event, Promise(Never, Void)) =
    (event : Html.Event) : Promise(Never, Void) { next {  } }

  property children : Array(Html) = []
  property disabled : Bool = false

  style base {
    justify-content: center;
    background: #{titleColor};
    display: inline-flex;
    align-items: center;
    border-radius: 2px;
    font-weight: bold;
    cursor: pointer;
    padding: 0 20px;
    outline: none;
    height: 40px;
    color: #{textColor};
    border: 0;
    transition: 0.5s;

    &:disabled {
      opacity: 0.5;
    }

    &:hover,
    &:focus {
      background: #{secondaryColor};
    }
  }

  fun render : Html {
    <div::base
      onClick={onClick}
      disabled={disabled}>

      <{ children }>

    </div>
  }
}
