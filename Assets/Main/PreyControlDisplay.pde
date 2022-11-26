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
        m_SplitBar.SetProgress(m_SplitBar.GetProgress() + m_ConnectedPreyController.GetCurrentSplitTime() / m_ConnectedPreyController.GetSplitTime());
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

        // Create Split progress bar
        GameObject splitBar =  m_Scene.AddGameObject(new UIElement("Prey Split Progressbar Object"), m_MenuBackground.transform());
        splitBar.SetTag("AnimalControlDisplay");
        m_SplitBar = (Progressbar) splitBar.AddComponent(new Progressbar("Prey Split Progressbar"));
        m_SplitBar.SetMargin(new PVector(25f, 25f));
        m_SplitBar.SetSize(new PVector(m_MenuWidth - 100f, 50f));
        m_SplitBar.transform().SetLocalPosition(new PVector(0f, 250f));
    }
}