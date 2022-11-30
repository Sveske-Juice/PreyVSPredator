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

    private Text m_Fps;
    private Text m_PhyFM;
    private Text m_ObjFM;
    private Text m_UIFM;
    private Text m_PreyCount;

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
        if (m_ShowingMenu)
            UpdateMenu();

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

        // Total fps and frame time
        GameObject fmObj = m_Scene.AddGameObject(new UIElement("Frame Time Text Object"), m_Background.transform());
        m_Fps = (Text) fmObj.AddComponent(new Text("Total Frame Time Text"));
        m_Fps.SetMargin(new PVector(10f, 10f));

        // Physics frame time
        GameObject phyObj = m_Scene.AddGameObject(new UIElement("Physics Frame Time Text Object"), m_Background.transform());
        m_PhyFM = (Text) phyObj.AddComponent(new Text("Physics Frame Time Text"));
        m_PhyFM.SetMargin(new PVector(10f, 10f));
        m_PhyFM.SetTextColor(color(255, 255, 0));
        m_PhyFM.transform().SetLocalPosition(new PVector(0f, 100f));

        // Object frame time
        GameObject objObj = m_Scene.AddGameObject(new UIElement("Object Frame Time Text Object"), m_Background.transform());
        m_ObjFM = (Text) objObj.AddComponent(new Text("Object Frame Time Text"));
        m_ObjFM.SetMargin(new PVector(10f, 10f));
        m_ObjFM.SetTextColor(color(255, 255, 0));
        m_ObjFM.transform().SetLocalPosition(new PVector(0f, 150f));

        // UI frame time
        GameObject uiObj = m_Scene.AddGameObject(new UIElement("UI Frame Time Text Object"), m_Background.transform());
        m_UIFM = (Text) uiObj.AddComponent(new Text("UI Frame Time Text"));
        m_UIFM.SetMargin(new PVector(10f, 10f));
        m_UIFM.SetTextColor(color(255, 255, 0));
        m_UIFM.transform().SetLocalPosition(new PVector(0f, 200f));

        // Prey count
        GameObject preyObj = m_Scene.AddGameObject(new UIElement("Prey Count Text Object"), m_Background.transform());
        m_PreyCount = (Text) preyObj.AddComponent(new Text("Prey Count Text"));
        m_PreyCount.SetMargin(new PVector(50f, 10f));
        m_PreyCount.SetTextColor(color(255, 200, 0));
        m_PreyCount.transform().SetLocalPosition(new PVector(0f, 300f));

        m_ShowingMenu = true;
    }

    private void HideMenu()
    {
        m_Background.GetGameObject().Destroy();

        m_ShowingMenu = false;
    }

    private void UpdateMenu()
    {
        m_Fps.SetText("FPS: " + m_Scene.GetFPS() + "                               frametime: " + Time.dt() + "ms");
        m_PhyFM.SetText("Physics Frame Time: " + m_Scene.GetPhysicsFM() + "ms");
        m_ObjFM.SetText("Object Tick Frame Time: " + (m_Scene.GetLateObjectFM() + m_Scene.GetObjectFM()) + "ms");
        m_UIFM.SetText("UI Tick Frame Time: " + (m_Scene.GetLateUIFM() + m_Scene.GetUIFM()) + "ms");
        m_PreyCount.SetText("Preys in scene: " + m_Scene.GetCurrentPreyCount());
    }
}