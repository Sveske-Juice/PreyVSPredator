public class MapSetupDisplayObject extends UIElement
{
    public MapSetupDisplayObject()
    {
        super("Map Setup Display Object");
    }

    @Override
    public void CreateComponents()
    {
        AddComponent(new MapSetupDisplay());
    }
}

public class MapSetupDisplay extends Component
{
    /* Members. */
    private Scene m_Scene;
    private ZVector m_MenuPosition;
    private float m_MenuWidth = 800f;
    private float m_MenuHeight = height - 50f;
    private color m_MenuBackgroundColor = color(12, 32, 51);
    private Polygon m_MenuBackground;
    private IButtonEventListener m_SmallButtonHandler = new IButtonEventListener()
    {
        @Override
        public void OnClick()
        {
            g_SceneManager.AddScene(new GameScene(new SmallGameSettings()));
            g_SceneManager.LoadScene("Game Scene");
        }
    };

    private IButtonEventListener m_MediumButtonHandler = new IButtonEventListener()
    {
        @Override
        public void OnClick()
        {
            g_SceneManager.AddScene(new GameScene(new MediumGameSettings()));
            g_SceneManager.LoadScene("Game Scene");
        }
    };
    
    private IButtonEventListener m_BigButtonHandler = new IButtonEventListener()
    {
        @Override
        public void OnClick()
        {
            g_SceneManager.AddScene(new GameScene(new BigGameSettings()));
            g_SceneManager.LoadScene("Game Scene");
        }
    };

    private IButtonEventListener m_EpicButtonHandler = new IButtonEventListener()
    {
        @Override
        public void OnClick()
        {
            g_SceneManager.AddScene(new GameScene(new EpicGameSettings()));
            g_SceneManager.LoadScene("Game Scene");
        }
    };

    private IButtonEventListener m_CustomButtonHandler = new IButtonEventListener()
    {
        @Override
        public void OnClick()
        {
            g_SceneManager.AddScene(new GameScene(new EpicGameSettings()));
            g_SceneManager.LoadScene("Game Scene");
        }
    };

    /* Getters/Setters. */

    @Override
    public void Start()
    {
        m_Scene = m_GameObject.GetBelongingToScene();
        m_MenuPosition = new ZVector(width / 2f - m_MenuWidth / 2f, height / 2f - m_MenuHeight / 2f); // Center menu
        transform().SetPosition(m_MenuPosition);
        CreateMenu();
    }

    private void CreateMenu()
    {
        /*
         * Create map setup menu during runtime.
        */

        // Create background for menu
        GameObject menuBackground = m_Scene.AddGameObject(new UIElement("Map Setup Display Menu Background"), transform());
        m_MenuBackground = (Polygon) menuBackground.AddComponent(new Polygon(createShape(RECT, 0f, 0f, m_MenuWidth, m_MenuHeight, 25f)));
        m_MenuBackground.GetShape().setFill(m_MenuBackgroundColor);

        // Title text
        GameObject setupTitle = m_Scene.AddGameObject(new UIElement("Map Setup Display Title Object"), m_MenuBackground.transform());
        Text setupTitleTxt = (Text) setupTitle.AddComponent(new Text("Map Setup Display Title"));
        setupTitleTxt.SetText("Chose your sim size");
        setupTitleTxt.transform().SetLocalPosition(new ZVector(m_MenuWidth / 2f, 0f)); // Center-top text
        setupTitleTxt.SetVerticalAlign(CENTER);
        setupTitleTxt.SetHorizontalAlign(CENTER);
        setupTitleTxt.SetSize(48);
        setupTitleTxt.SetMargin(new ZVector(0f, 50f));

        // Small sim button
        GameObject smallBtnObj = m_Scene.AddGameObject(new Button("Small Sim Button"), m_MenuBackground.transform());
        ButtonBehaviour smallBtn = smallBtnObj.GetComponent(ButtonBehaviour.class);
        smallBtn.SetSize(new ZVector(350f, 150f));
        smallBtn.SetCornerRadius(25f);
        smallBtn.SetText("Small sim");
        smallBtn.SetTextSize(48);
        smallBtnObj.GetTransform().SetLocalPosition(new ZVector(25f, m_MenuHeight / 100 * 15));
        smallBtn.AddButtonListener(m_SmallButtonHandler);

        // Medium sim button
        GameObject medBtnObj = m_Scene.AddGameObject(new Button("Medium Sim Button"), m_MenuBackground.transform());
        ButtonBehaviour medBtn = medBtnObj.GetComponent(ButtonBehaviour.class);
        medBtn.SetSize(new ZVector(350f, 150f));
        medBtn.SetCornerRadius(25f);
        medBtn.SetText("Medium sim");
        medBtn.SetTextSize(48);
        medBtnObj.GetTransform().SetLocalPosition(new ZVector(m_MenuWidth - 25f - medBtn.GetSize().x, m_MenuHeight / 100 * 15));
        medBtn.AddButtonListener(m_MediumButtonHandler);

        // Big sim button
        GameObject bigBtnObj = m_Scene.AddGameObject(new Button("Big Sim Button"), m_MenuBackground.transform());
        ButtonBehaviour bigBtn = bigBtnObj.GetComponent(ButtonBehaviour.class);
        bigBtn.SetSize(new ZVector(350f, 150f));
        bigBtn.SetCornerRadius(25f);
        bigBtn.SetText("Big sim");
        bigBtn.SetTextSize(48);
        bigBtnObj.GetTransform().SetLocalPosition(new ZVector(25f, m_MenuHeight / 100 * 35));
        bigBtn.AddButtonListener(m_BigButtonHandler);

        // Epic sim button
        GameObject epicBtnObj = m_Scene.AddGameObject(new Button("Epic Sim Button"), m_MenuBackground.transform());
        ButtonBehaviour epicBtn = epicBtnObj.GetComponent(ButtonBehaviour.class);
        epicBtn.SetSize(new ZVector(350f, 150f));
        epicBtn.SetCornerRadius(25f);
        epicBtn.SetText("Epic sim");
        epicBtn.SetTextSize(48);
        epicBtnObj.GetTransform().SetLocalPosition(new ZVector(m_MenuWidth - 25f - bigBtn.GetSize().x, m_MenuHeight / 100 * 35));
        epicBtn.AddButtonListener(m_EpicButtonHandler);

        // Custom sim button
        GameObject customBtnObj = m_Scene.AddGameObject(new Button("Epic Sim Button"), m_MenuBackground.transform());
        ButtonBehaviour customBtn = customBtnObj.GetComponent(ButtonBehaviour.class);
        customBtn.SetSize(new ZVector(450f, 200f));
        customBtn.SetCornerRadius(25f);
        customBtn.SetText("Custom sim");
        customBtn.SetTextSize(48);
        customBtnObj.GetTransform().SetLocalPosition(new ZVector(m_MenuWidth / 2f - customBtn.GetSize().x / 2f, m_MenuHeight / 100 * 60));
        customBtn.AddButtonListener(m_EpicButtonHandler);
    }
}
