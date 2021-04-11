component Molecules.Form.Input {
  connect Theme exposing { containerBackground, secondaryColor }

  property onInput : Function(Html.Event, Promise(Never, Void))

  property label : String
  property id : String

  property defaultValue = ""
  property type="text"

  style base {
    position: relative;
    margin-bottom: 24px;
    width: 100%;
  }

  style input {
    font-family: inherit;
    width: 100%;
    display:block;
    border: 0;
    border-bottom: 1px solid white;
    outline: 0;
    font-size: 1rem;
    color: white;
    padding: 18px 12px;
    background: transparent;
    transition: border-color 0.2s;
  
    &:required,&:invalid { box-shadow:none; }
  
    &::placeholder {
      color: transparent;
    }
    &:placeholder-shown {
      border-color: white;
     }

    &:placeholder-shown ~ label {
      font-size: 1rem;
      cursor: text;
      transform:translatey(17px);
      padding:0px 0px;
    }

    &:focus {
      ~ label {
        position: absolute;
        transform:translatey(-7px);
        color: #{secondaryColor};
        padding:0px 4px;
        font-size: 0.75rem;
      } 
      border-width: 1px;
      border-color: #{secondaryColor};
    }
  }

  style label {
    position: absolute;
    left:12px;
    display: block;
    transform:translatey(-7px);
    transition: 0.3s;
    font-size: 0.75rem;
    padding:0px 4px;
    color: white;
    background: #{containerBackground};
    top:0;
  }

  style focus-bg {
  }

  fun render : Html {
    <div::base>
      <input::input 
        type={type} 
        id={id} 
        name={id} 
        placeholder={label} 
        value={defaultValue}
        onInput={onInput}
      />
      <label::label for={id}> <{label}> </label>
      <span::focus-bg></span>
    </div>
  }
}
