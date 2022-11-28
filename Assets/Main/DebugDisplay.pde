// Prefab for creating the in-game debug information box
public class DebugDisplayObject extends GameObject
{
    /* Members. */


    public DebugDisplayObject()
    {
        super("Debug Display Object");
    }

    public DebugDisplayObject(String name)
    {
        super(name);
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        AddComponent(new DebugDisplay());
    }
}

public class DebugDisplay extends Component
{
    /* Members. */
    private Scene m_Scene;
    private boolean m_ShowingMenu = false;
    private Polygon m_Background;
    private float m_MenuWidth = 550f;
    private float m_MenuHeight = 350f;
    private PVector m_MenuPosition = new PVector(width - 10f - m_MenuWidth, 10f); // Top left corner
    private color m_MenuBackgroundColor = color(12, 32, 51, 220);

    private float m_CanToggleTime = 0.3f; // Time the menu have to be open/closed before it can be toggled again (so input doesn't fuck it up)
    private float m_OpenedDuration = 0f; // Amount of time menu was opened

    public DebugDisplay()
    {
        m_Name = "Debug Display";
    }

    public DebugDisplay(String name)
    {
        m_Name = name;
    }

    @Override
    public void Start()
    {
        m_Scene = m_GameObject.GetBelongingToScene();
    }

    @Override
    public void Update()
    {
        m_OpenedDuration += Time.dt();
        if (m_OpenedDuration < m_CanToggleTime)
            return;

        // If 'I' is pressed then toggle view of debug box
        if (InputManager.GetInstance().GetKey('i'))
        {
            ToggleMenu();
            m_OpenedDuration = 0f;
        }
    }

    private void ToggleMenu()
    {
        // If showing menu then hide it
        if (m_ShowingMenu)
            HideMenu();
        else
            ShowMenu();
    }

    private void ShowMenu()
    {
        // Set position of menu
        transform().SetPosition(m_MenuPosition);

        /*  Create menu. */

        // Create background
        GameObject menuBackground = m_Scene.AddGameObject(new UIElement("Debug Display Background Object"), transform());
        m_Background = (Polygon) menuBackground.AddComponent(new Polygon(createShape(RECT, 0f, 0f, m_MenuWidth, m_MenuHeight)));
        m_Background.GetShape().setFill(m_MenuBackgroundColor);

        // TODO show Frame times

        m_ShowingMenu = true;
    }

    private void HideMenu()
    {
        m_Background.GetGameObject().Destroy();

        m_ShowingMenu = false;
    }
}