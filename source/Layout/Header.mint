component Layout.Header {
  connect Theme exposing { containerBackground }

  property height : String

  style base {
    background-color: #{containerBackground};

    position: fixed;
    display: flex;

    height: #{height};
    width: 100vw;

    top: 0;
  }

  fun render : Html {
    <div::base>
    </div>
  }
}
