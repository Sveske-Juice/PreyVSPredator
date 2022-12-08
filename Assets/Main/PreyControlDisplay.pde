/*
 * Prefab for creating the prey control display when clicking on a prey
*/
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

/*
 * Behaviour class. Will handle displaying the prey control display when clicking on a prey.
*/
public class PreyControlDisplay extends AnimalControlDisplay implements IMouseEventListener
{
    /* Members. */
    private Text m_StateText;
    private Text m_PreysNearby;
    private Text m_SplitMultiplier;
    private Text m_SplitBlocked;
    private Progressbar m_SplitBar;
    private PreyController m_ConnectedPreyController;


    public PreyControlDisplay()
    {
        super("Prey Control Display");
    }

    @Override
    public void Start()
    {
        super.Start();

        m_Scene.FindGameObject("Mouse Event Initiator Handler").GetComponent(MouseEventInitiator.class).AddMouseEventListener(this);
    }

    @Override
    public void Update()
    {
        super.Update();

        if (!m_MenuBeingShowed)
            return;

        if (m_ConnectedAnimal.GetTag() != "Prey")
            return;
        
        m_ConnectedPreyController = m_ConnectedAnimal.GetComponent(PreyController.class);
        m_StateText.SetText("State: " + m_ConnectedPreyController.GetState());
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

        if (m_ConnectedAnimal.GetTag() != "Prey")
            return;

        // Create animal state text
        GameObject stateTxtObj = m_Scene.AddGameObject(new UIElement("Prey State Text Object"), m_MenuBackground.transform());
        stateTxtObj.SetTag("AnimalControlDisplay");
        m_StateText = (Text) stateTxtObj.AddComponent(new Text("Prey State Text"));
        m_StateText.SetMargin(new ZVector(25f, 25f));
        m_StateText.transform().SetLocalPosition(new ZVector(0f, 275f));   

        // Create preys nearby element
        GameObject preysNerby = m_Scene.AddGameObject(new UIElement("Prey Nearby Text Object"), m_MenuBackground.transform());
        preysNerby.SetTag("AnimalControlDisplay");
        m_PreysNearby = (Text) preysNerby.AddComponent(new Text("Prey Nearby Text"));
        m_PreysNearby.SetMargin(new ZVector(25f, 25f));
        m_PreysNearby.transform().SetLocalPosition(new ZVector(0f, 350f));      

        // Create Split multiplier text
        GameObject splitMultObj = m_Scene.AddGameObject(new UIElement("Split Multiplier Text Object"), m_MenuBackground.transform());
        preysNerby.SetTag("AnimalControlDisplay");
        m_SplitMultiplier = (Text) splitMultObj.AddComponent(new Text("Split Multiplier Text"));
        m_SplitMultiplier.SetMargin(new ZVector(25f, 25f));
        m_SplitMultiplier.SetSize(28);
        m_SplitMultiplier.SetTextColor(color(255, 255, 0));
        m_SplitMultiplier.transform().SetLocalPosition(new ZVector(0f, 400f)); 

        // Create split title
        GameObject splitTitle = m_Scene.AddGameObject(new UIElement("Split Title Object"), m_MenuBackground.transform());
        splitTitle.SetTag("AnimalControlDisplay");
        Text splitTitleTxt = (Text) splitTitle.AddComponent(new Text("Split Title"));
        splitTitleTxt.SetText("Split Progress:");
        splitTitleTxt.SetMargin(new ZVector(25f, 25f));
        splitTitleTxt.transform().SetLocalPosition(new ZVector(0f, 475f));

        // Create Split progress bar
        GameObject splitBar =  m_Scene.AddGameObject(new UIElement("Prey Split Progressbar Object"), m_MenuBackground.transform());
        splitBar.SetTag("AnimalControlDisplay");
        m_SplitBar = (Progressbar) splitBar.AddComponent(new Progressbar("Prey Split Progressbar"));
        m_SplitBar.SetMargin(new ZVector(25f, 25f));
        m_SplitBar.SetSize(new ZVector(m_MenuWidth - 100f, 50f));
        m_SplitBar.transform().SetLocalPosition(new ZVector(0f, 525f));

        // Create split block text
        GameObject splitBlockObj =  m_Scene.AddGameObject(new UIElement("Split Blocked Text Object"), m_MenuBackground.transform());
        splitBlockObj.SetTag("AnimalControlDisplay");
        m_SplitBlocked = (Text) splitBlockObj.AddComponent(new Text("Split Blocked Text"));
        m_SplitBlocked.SetMargin(new ZVector(25f, 25f));
        m_SplitBlocked.transform().SetLocalPosition(new ZVector(0f, 575f));
        m_SplitBlocked.SetTextColor(color(255, 0, 0));
        m_SplitBlocked.SetSize(20);
        m_SplitBlocked.SetText("");
    }

    /*
     * Gets called when the mouse is clicked on a collider.
     * Will handle showing the menu if a prey was clicked on.
    */
    @Override
    public void OnColliderClick(Collider collider)
    {
        // Check if it's a prey that was clicked on
        if (collider.GetGameObject() instanceof Prey)
        {
            ShowMenu((Animal) collider.GetGameObject());
        }
        else if (!(collider.GetGameObject() instanceof UIElement)) // If not ui element then hide menu
        {
            HideMenu();
        }
    }

    @Override
    public void OnMouseRelease(ZVector position) { }

    @Override
    public void OnMouseClick(ZVector position) { }

    @Override
    public void OnMouseDrag(ZVector position) { }
}