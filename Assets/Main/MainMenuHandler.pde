public class MainMenuHandlerObject extends GameObject
{
    public MainMenuHandlerObject()
    {
        super("Main Menu Handler");
    }

    @Override
    public void CreateComponents()
    {
        AddComponent(new MainMenuHandler());
    }
}


public class MainMenuHandler extends Component
{
    /* Members. */
    private Scene m_Scene;
    private GameObject m_PlayButton;
    private boolean m_ShouldShowMenu = false;

    /*
     * Button event handler. Will handle playing the game
     * when pressing the play game button.
    */
    private IButtonEventListener m_PlayGameHandler = new IButtonEventListener()
    {
        @Override
        public void OnClick()
        {
            // Show map setup menu if not already shown
            if (m_Scene.FindGameObject("Map Setup Display Object") != null)
                return;
            
            m_Scene.AddGameObject(new MapSetupDisplayObject());

            // Destroy this button
            m_PlayButton.Destroy();
        }
    };

    /* Getters/Setters. */

    @Override
    public void Start()
    {
        m_Scene = m_GameObject.GetBelongingToScene();
        m_ShouldShowMenu = true;
    }

    @Override void Update()
    {
        // Create the menu in the first frame (not in start because it will start the object twice (issue))
        if (m_ShouldShowMenu)
            CrateMenu();
        
        m_ShouldShowMenu = false;
    }

    private void CrateMenu()
    {
        /*
         * Create Main Menu.
        */
        GameObject greeter = m_Scene.AddGameObject(new UIElement());
        Text greeterTxt = (Text) greeter.AddComponent(new Text());
        greeterTxt.transform().SetPosition(new ZVector(width/2f, 100f));
        greeterTxt.SetVerticalAlign(CENTER);
        greeterTxt.SetHorizontalAlign(CENTER);
        greeterTxt.SetSize(48);
        greeterTxt.SetText("Welcome");

        // Play button
        m_PlayButton = m_Scene.AddGameObject(new Button("Play Button"));
        ButtonBehaviour playBtn = m_PlayButton.GetComponent(ButtonBehaviour.class);
        playBtn.SetSize(new ZVector(500f, 250f));
        playBtn.SetCornerRadius(50f);
        playBtn.SetText("Play");
        playBtn.SetTextSize(48);
        m_PlayButton.GetTransform().SetPosition(ZVector.sub(new ZVector(width / 2f, height / 2f), ZVector.mult(playBtn.GetSize(), 0.5f))); // Center button (subtract half extents)
        playBtn.AddButtonListener(m_PlayGameHandler);
    }
}