public class PreyControlDisplayObject extends GameObject
{
    public PreyControlDisplayObject()
    {
        super("Prey Control Display");
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        AddComponent(new PreyControlDisplay());
    }
}

public class PreyControlDisplay extends AnimalControlDisplay
{
    /* Members. */
    private Text m_PreysNearby;
    private Text m_SplitMultiplier;
    private Text m_SplitBlocked;
    private Progressbar m_SplitBar;
    private PreyController m_ConnectedPreyController;


    public PreyControlDisplay()
    {
        super();
    }

    @Override
    public void Update()
    {
        super.Update();

        if (!m_MenuBeingShowed)
            return;

        m_ConnectedPreyController = m_ConnectedAnimal.GetComponent(PreyController.class);
        m_PreysNearby.SetText("Nearby Preys: " + m_ConnectedPreyController.GetNearbyPreys());
        m_SplitMultiplier.SetText("Split Multiplier: " + m_ConnectedPreyController.GetSplitMultiplier());
        m_SplitBar.SetProgress(m_ConnectedPreyController.GetCurrentSplitTime() / m_ConnectedPreyController.GetSplitTime());
        
        if (m_ConnectedPreyController.GetNearbyPreys() >= m_ConnectedPreyController.GetMaxNearbyPreys())
            m_SplitBlocked.SetText("Blocked because to many preys are nearby!");
        else if (m_Scene.GetCurrentPreyCount() >= m_Scene.GetMaxPreyCount())
            m_SplitBlocked.SetText("Blocked because prey count has reached maximum! (" + m_Scene.GetMaxPreyCount() + ")");
    }

    /* Prey specific menu attributes. */
    @Override
    protected void CreateMenu()
    {
        super.CreateMenu();

        // Create preys nearby element
        GameObject preysNerby = m_Scene.AddGameObject(new UIElement("Prey Nearby Text Object"), m_MenuBackground.transform());
        preysNerby.SetTag("AnimalControlDisplay");
        m_PreysNearby = (Text) preysNerby.AddComponent(new Text("Prey Nearby Text"));
        m_PreysNearby.SetMargin(new PVector(25f, 25f));
        m_PreysNearby.transform().SetLocalPosition(new PVector(0f, 100f));      

        // Create Split multiplier text
        GameObject splitMultObj = m_Scene.AddGameObject(new UIElement("Split Multiplier Text Object"), m_MenuBackground.transform());
        preysNerby.SetTag("AnimalControlDisplay");
        m_SplitMultiplier = (Text) splitMultObj.AddComponent(new Text("Split Multiplier Text"));
        m_SplitMultiplier.SetMargin(new PVector(25f, 25f));
        m_SplitMultiplier.SetSize(28);
        m_SplitMultiplier.SetTextColor(color(255, 255, 0));
        m_SplitMultiplier.transform().SetLocalPosition(new PVector(0f, 175f)); 

        // Create split title
        GameObject splitTitle = m_Scene.AddGameObject(new UIElement("Split Title Object"), m_MenuBackground.transform());
        splitTitle.SetTag("AnimalControlDisplay");
        Text splitTitleTxt = (Text) splitTitle.AddComponent(new Text("Split Title"));
        splitTitleTxt.SetText("Split Progress:");
        splitTitleTxt.SetMargin(new PVector(25f, 25f));
        splitTitleTxt.transform().SetLocalPosition(new PVector(0f, 250f));

        // Create Split progress bar
        GameObject splitBar =  m_Scene.AddGameObject(new UIElement("Prey Split Progressbar Object"), m_MenuBackground.transform());
        splitBar.SetTag("AnimalControlDisplay");
        m_SplitBar = (Progressbar) splitBar.AddComponent(new Progressbar("Prey Split Progressbar"));
        m_SplitBar.SetMargin(new PVector(25f, 25f));
        m_SplitBar.SetSize(new PVector(m_MenuWidth - 100f, 50f));
        m_SplitBar.transform().SetLocalPosition(new PVector(0f, 300f));

        GameObject splitBlockObj =  m_Scene.AddGameObject(new UIElement("Split Blocked Text Object"), m_MenuBackground.transform());
        splitBlockObj.SetTag("AnimalControlDisplay");
        m_SplitBlocked = (Text) splitBlockObj.AddComponent(new Text("Split Blocked Text"));
        m_SplitBlocked.SetMargin(new PVector(25f, 25f));
        m_SplitBlocked.transform().SetLocalPosition(new PVector(0f, 350f));
        m_SplitBlocked.SetTextColor(color(255, 0, 0));
        m_SplitBlocked.SetSize(20);
        m_SplitBlocked.SetText("");
    }
}