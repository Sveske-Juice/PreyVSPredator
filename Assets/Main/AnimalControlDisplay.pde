// Base behaviour class for displaying control side menu on any animal
public class AnimalControlDisplay extends Component implements IMouseEventListener
{
    /* Members. */
    protected Scene m_Scene;
    protected PVector m_MenuPosition = new PVector(10f, 10f);

    protected float m_MenuWidth = 600f;
    protected float m_MenuHeight;
    protected color m_MenuBackgroundColor = color(12, 32, 51, 220);

    protected boolean m_MenuBeingShowed = false;
    protected Animal m_ConnectedAnimal; // Animal showing stats about

    protected Polygon m_MenuBackground;
    protected Text m_PositionText;


    @Override
    public void Start()
    {
        m_MenuHeight = height - m_MenuPosition.y * 4; // Use Start() since "height" is initialized here

        // Register this class to get mouse events
        m_Scene = m_GameObject.GetBelongingToScene();
        m_Scene.FindGameObject("Mouse Event Initiator Handler").GetComponent(MouseEventInitiator.class).AddMouseEventListener(this);
    }

    @Override
    public void Update()
    {
        if (!m_MenuBeingShowed)
            return;

        // Update values on menu
        m_PositionText.SetText("Animal Position: " + m_ConnectedAnimal.GetTransform().GetPosition());
    }

    private void ShowMenu()
    {
        println("Showing menu");
        CreateMenu();
        m_MenuBeingShowed = true;
    }

    private void HideMenu()
    {
        println("Hiding menu");
        m_MenuBeingShowed = false;

    }

    protected void CreateMenu()
    {
        // Set position of menu
        transform().SetPosition(m_MenuPosition);

        /* Create all UI GameObjects that make up the control display. */
        
        // Create background for menu
        GameObject menuBackground = m_Scene.AddGameObject(new UIElement("Animal Control Display Menu Background"), transform());
        menuBackground.SetTag("AnimalControlDisplay");
        m_MenuBackground = (Polygon) menuBackground.AddComponent(new Polygon(createShape(RECT, 0f, 0f, m_MenuWidth, m_MenuHeight)));
        m_MenuBackground.GetShape().setFill(m_MenuBackgroundColor);

        // Create statistics text element
        GameObject statTitle = m_Scene.AddGameObject(new UIElement("Statistics Title Object"), menuBackground.GetTransform());
        statTitle.SetTag("AnimalControlDisplay");
        Text statTitleTxt = (Text) statTitle.AddComponent(new Text("Statestics Title"));
        statTitleTxt.SetText("Animal Statistics");
        statTitleTxt.SetSize(32);
        statTitleTxt.SetMargin(new PVector(25f, 25f));

        // Create position text element
        GameObject positionTextObj = m_Scene.AddGameObject(new UIElement("Position Text Object"), menuBackground.GetTransform());
        positionTextObj.SetTag("AnimalControlDisplay");
        m_PositionText = (Text) positionTextObj.AddComponent(new Text("Position text"));
        m_PositionText.SetMargin(new PVector(25f, 25f));
        m_PositionText.transform().SetLocalPosition(new PVector(0f, 50f));
    }

    // If an animal was clicked on, then show the control display
    public void OnColliderClick(Collider collider)
    {
        // Check if it's an animal that was clicked on
        if (collider.GetGameObject() instanceof Animal)
        {
            m_ConnectedAnimal = (Animal) collider.GetGameObject();
            ShowMenu();
            return;
        }
        
        // Hide the menu if the GameObject clicked wasn't connected to the Control Display (outside the side menu)
        if (collider.GetGameObject().GetTag() != "AnimalControlDisplay")
            HideMenu();
    }

    public void OnMouseClick(PVector position)
    {

    }

    public void OnMouseDrag(PVector position)
    {
        // TODO Hide the menu if the mouse gets dragged outside the menu
    }

    public void OnMouseRelease(PVector position)
    {

    }
}