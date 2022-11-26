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


    public PreyControlDisplay()
    {
        super();
    }

    @Override
    public void Start()
    {
        super.Start();

        
    }

    /* Prey specific menu attributes. */
    @Override
    protected void CreateMenu()
    {
        super.CreateMenu();

        // Create preys nearby element
        GameObject preysNerby = m_Scene.AddGameObject(new UIElement("Prey Nearby Text Object"), m_MenuBackground.transform());
        preysNerby.SetTag("AnimalControlDisplay");
        m_PreysNearby = (Text) preysNerby.AddComponent(new Text("Prey Nearby Text Object"));
        m_PreysNearby.SetMargin(new PVector(25f, 25f));

        m_PreysNearby.transform().SetLocalPosition(new PVector(0f, 50f));
        
        
        
    }
}