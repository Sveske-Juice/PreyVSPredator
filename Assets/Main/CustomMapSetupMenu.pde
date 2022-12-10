public class CustomMapSeupMenuObject extends UIElement
{
    public CustomMapSeupMenuObject()
    {
        super("Custom Map Setup Menu Object");
    }

    @Override
    public void CreateComponents()
    {
        AddComponent(new CustomMapSeupMenu());
    }
}

public class CustomMapSeupMenu extends Component
{
    /* Members. */
    private Scene m_Scene;
    private ZVector m_MenuPosition;
    private float m_MenuWidth = 800f;
    private float m_MenuHeight = height - 50f;
    private color m_MenuBackgroundColor = color(12, 32, 51);
    private Polygon m_MenuBackground;

    private Slider m_MaxPreySlider;
    private Slider m_CurrentPreySlider;
    private Slider m_PreySplitSlider;
    private Slider m_MaxPredatorSlider;
    private Slider m_CurrentPredatorSlider;
    private Slider m_AnimalSpeedSlider;
    private Slider m_PredatorHuntSpeedSlider;
    private Slider m_BushSlider;
    private GameObject m_PlayButton;

    /*
     * Button event lister, which will handle playing the game with the custom game settings.
    */
    private IButtonEventListener m_PlayGameHandler = new IButtonEventListener()
    {
        @Override
        public void OnClick()
        {
            // Create GameSettings from slider values
            GameSettings gameSettings = new GameSettings(   (int) m_MaxPreySlider.GetProgress(), (int) m_CurrentPreySlider.GetProgress(), 
                                                            (int) m_MaxPredatorSlider.GetProgress(), (int) m_CurrentPredatorSlider.GetProgress(), 
                                                            (int) m_BushSlider.GetProgress(), m_PreySplitSlider.GetProgress(), 
                                                            m_AnimalSpeedSlider.GetProgress(), m_PredatorHuntSpeedSlider.GetProgress());
            
            // Create game scene with custom game settings
            g_SceneManager.AddScene(new GameScene(gameSettings, "Game Scene"));

            // Load game scene
            g_SceneManager.LoadScene("Game Scene");
        }
    };

    @Override
    public void Start()
    {
        m_Scene = m_GameObject.GetBelongingToScene();
        m_MenuPosition = new ZVector(width / 2f - m_MenuWidth / 2f, height / 2f - m_MenuHeight / 2f); // Center menu
        transform().SetPosition(m_MenuPosition);
        CreateMenu();
    }

    /*
     * Create map setup menu during runtime.
    */
    private void CreateMenu()
    {
        // Create background for menu
        GameObject menuBackground = m_Scene.AddGameObject(new UIElement("Custom Map Setup Display Menu Background"), transform());
        m_MenuBackground = (Polygon) menuBackground.AddComponent(new Polygon(createShape(RECT, 0f, 0f, m_MenuWidth, m_MenuHeight, 25f)));
        m_MenuBackground.GetShape().setFill(m_MenuBackgroundColor);

        // Create custom map setup title
        GameObject setupTitle = m_Scene.AddGameObject(new UIElement("Custom Map Setup Display Title Object"), m_MenuBackground.transform());
        Text setupTitleTxt = (Text) setupTitle.AddComponent(new Text("Custom Map Setup Display Title"));
        setupTitleTxt.SetText("Chose your custom map settings");
        setupTitleTxt.transform().SetLocalPosition(new ZVector(m_MenuWidth / 2f, 0f)); // Center-top text
        setupTitleTxt.SetVerticalAlign(CENTER);
        setupTitleTxt.SetHorizontalAlign(CENTER);
        setupTitleTxt.SetSize(48);
        setupTitleTxt.SetMargin(new ZVector(0f, 50f));

        // Slider for Max prey count
        SliderObject maxPreyCntSliderObj = (SliderObject) m_Scene.AddGameObject(new SliderObject(), menuBackground.GetTransform());
        m_MaxPreySlider = maxPreyCntSliderObj.GetComponent(Slider.class);
        m_MaxPreySlider.SetMargin(new ZVector(75f, 25f));
        m_MaxPreySlider.SetSliderLength(250f);
        m_MaxPreySlider.SetMaxValue(5000f);
        m_MaxPreySlider.SetMinValue(1f);
        m_MaxPreySlider.transform().SetLocalPosition(new ZVector(0f, 200f));

        // Create title for max prey count
        Text maxPreyTxt = (Text) maxPreyCntSliderObj.AddComponent(new Text("Max Prey slider title"));
        maxPreyTxt.SetText("Max Preys in scene:");
        maxPreyTxt.SetMargin(new ZVector(75f, -25f));

        // Slider for start prey count
        SliderObject curPreyCntSliderObj = (SliderObject) m_Scene.AddGameObject(new SliderObject(), menuBackground.GetTransform());
        m_CurrentPreySlider = curPreyCntSliderObj.GetComponent(Slider.class);
        m_CurrentPreySlider.SetMargin(new ZVector(75f, 25f));
        m_CurrentPreySlider.SetMaxValue(1000f);
        m_CurrentPreySlider.SetSliderLength(250f);
        m_CurrentPreySlider.SetMinValue(1f);
        m_CurrentPreySlider.SetProgress(50f);
        m_CurrentPreySlider.transform().SetLocalPosition(new ZVector(m_MenuWidth / 2f, 200f));

        // Create title for max prey count
        Text curPreyTxt = (Text) curPreyCntSliderObj.AddComponent(new Text("Start Prey slider title"));
        curPreyTxt.SetText("Preys at the start of the game:");
        curPreyTxt.SetMargin(new ZVector(50f, -25f));

        // Slider for prey split time
        SliderObject preySplitSliderObj = (SliderObject) m_Scene.AddGameObject(new SliderObject(), menuBackground.GetTransform());
        m_PreySplitSlider = preySplitSliderObj.GetComponent(Slider.class);
        m_PreySplitSlider.SetMargin(new ZVector(75f, 25f));
        m_PreySplitSlider.SetSliderLength(250f);
        m_PreySplitSlider.SetMaxValue(60f);
        m_PreySplitSlider.SetMinValue(1f);
        m_PreySplitSlider.transform().SetLocalPosition(new ZVector(0f, 300f));

        // Create title for max prey count
        Text preysSplitTxt = (Text) preySplitSliderObj.AddComponent(new Text("Prey Split slider title"));
        preysSplitTxt.SetText("Time between prey split:");
        preysSplitTxt.SetMargin(new ZVector(75f, -25f));

        // Slider for bush count
        SliderObject bushSliderObj = (SliderObject) m_Scene.AddGameObject(new SliderObject(), menuBackground.GetTransform());
        m_BushSlider = bushSliderObj.GetComponent(Slider.class);
        m_BushSlider.SetMargin(new ZVector(75f, 25f));
        m_BushSlider.SetSliderLength(250f);
        m_BushSlider.SetMaxValue(100f);
        m_BushSlider.SetMinValue(0f);
        m_BushSlider.transform().SetLocalPosition(new ZVector(m_MenuWidth / 2f, 300f));

        // Create title for max prey count
        Text bushTxt = (Text) bushSliderObj.AddComponent(new Text("Bush count slider title"));
        bushTxt.SetText("Number of bushes:");
        bushTxt.SetMargin(new ZVector(50f, -25f));

        // Slider for Max predator count
        SliderObject maxPredCntSliderObj = (SliderObject) m_Scene.AddGameObject(new SliderObject(), menuBackground.GetTransform());
        m_MaxPredatorSlider = maxPredCntSliderObj.GetComponent(Slider.class);
        m_MaxPredatorSlider.SetMargin(new ZVector(75f, 25f));
        m_MaxPredatorSlider.SetMaxValue(2500f);
        m_MaxPredatorSlider.SetSliderLength(250f);
        m_MaxPredatorSlider.SetMinValue(1f);
        m_MaxPredatorSlider.transform().SetLocalPosition(new ZVector(0f, 450f));

        // Create title for max prey count
        Text maxPredTxt = (Text) maxPredCntSliderObj.AddComponent(new Text("Max Predator slider title"));
        maxPredTxt.SetText("Max predators in scene:");
        maxPredTxt.SetMargin(new ZVector(75f, -25f));

        // Slider for start predator count
        SliderObject curPredCntSliderObj = (SliderObject) m_Scene.AddGameObject(new SliderObject(), menuBackground.GetTransform());
        m_CurrentPredatorSlider = curPredCntSliderObj.GetComponent(Slider.class);
        m_CurrentPredatorSlider.SetMargin(new ZVector(75f, 25f));
        m_CurrentPredatorSlider.SetSliderLength(250f);
        m_CurrentPredatorSlider.SetMaxValue(500f);
        m_CurrentPredatorSlider.SetMinValue(1f);
        m_CurrentPredatorSlider.SetProgress(50f);
        m_CurrentPredatorSlider.transform().SetLocalPosition(new ZVector(m_MenuWidth / 2f, 450f));

        // Create title for max prey count
        Text curPredTxt = (Text) curPredCntSliderObj.AddComponent(new Text("Start Predator slider title"));
        curPredTxt.SetText("Predators at the start of the game:");
        curPredTxt.SetMargin(new ZVector(50f, -25f));

        // Slider for animal speed
        SliderObject animalSpeedSliderObj = (SliderObject) m_Scene.AddGameObject(new SliderObject(), menuBackground.GetTransform());
        m_AnimalSpeedSlider = animalSpeedSliderObj.GetComponent(Slider.class);
        m_AnimalSpeedSlider.SetMargin(new ZVector(75f, 25f));
        m_AnimalSpeedSlider.SetSliderLength(250f);
        m_AnimalSpeedSlider.SetMaxValue(1000f);
        m_AnimalSpeedSlider.SetMinValue(250f);
        m_AnimalSpeedSlider.SetProgress(50f);
        m_AnimalSpeedSlider.transform().SetLocalPosition(new ZVector(0f, 600f));

        // Create title for max prey count
        Text animalSpeedTxt = (Text) animalSpeedSliderObj.AddComponent(new Text("Animal movement speed slider title"));
        animalSpeedTxt.SetText("Animal movement speed:");
        animalSpeedTxt.SetMargin(new ZVector(75f, -25f));

        // Slider for predator hunt speed
        SliderObject huntSpeedSliderObj = (SliderObject) m_Scene.AddGameObject(new SliderObject(), menuBackground.GetTransform());
        m_PredatorHuntSpeedSlider = huntSpeedSliderObj.GetComponent(Slider.class);
        m_PredatorHuntSpeedSlider.SetMargin(new ZVector(75f, 25f));
        m_PredatorHuntSpeedSlider.SetSliderLength(250f);
        m_PredatorHuntSpeedSlider.SetMaxValue(1000f);
        m_PredatorHuntSpeedSlider.SetMinValue(250f);
        m_PredatorHuntSpeedSlider.SetProgress(50f);
        m_PredatorHuntSpeedSlider.transform().SetLocalPosition(new ZVector(m_MenuWidth / 2f, 600f));

        // Create title for max prey count
        Text huntSpeedTxt = (Text) huntSpeedSliderObj.AddComponent(new Text("Predator hunt movement speed slider title"));
        huntSpeedTxt.SetText("Predator hunt speed:");
        huntSpeedTxt.SetMargin(new ZVector(50f, -25f));

        // Play button
        m_PlayButton = m_Scene.AddGameObject(new Button("Custom Play Button"));
        ButtonBehaviour playBtn = m_PlayButton.GetComponent(ButtonBehaviour.class);
        playBtn.SetSize(new ZVector(300f, 150f));
        playBtn.SetCornerRadius(25f);
        playBtn.SetText("Play");
        playBtn.SetTextSize(48);
        m_PlayButton.GetTransform().SetPosition(ZVector.sub(new ZVector(width / 2f, 900f), ZVector.mult(playBtn.GetSize(), 0.5f))); // Center button (subtract half extents)
        playBtn.AddButtonListener(m_PlayGameHandler);
    }
}