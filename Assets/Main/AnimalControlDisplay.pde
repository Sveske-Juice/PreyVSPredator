// Base behaviour class for displaying control side menu on any animal
public class AnimalControlDisplay extends Component implements IMouseEventListener
{
    /* Members. */
    private Scene m_Scene;
    private Polygon m_MenuBackground;
    private PVector m_MenuPosition = new PVector(10f, 10f);

    private float m_MenuWidth = 600f;
    private float m_MenuHeight;
    private color m_MenuBackgroundColor = color(12, 32, 51, 220);

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
        if (m_MenuBackground != null)
            println("Position: " + m_MenuBackground.transform().GetPosition());
    }

    private void ShowMenu()
    {
        println("Showing menu");
        CreateMenu();
    }

    private void HideMenu()
    {
        println("Hiding menu");

    }

    private void CreateMenu()
    {
        // Create all UI GameObjects that make up the control display
        GameObject menuBackground = m_Scene.AddGameObject(new UIElement("Animal Control Display Menu Background"), transform());
        menuBackground.SetTag("AnimalControlDisplay");
        m_MenuBackground = (Polygon) menuBackground.AddComponent(new Polygon(createShape(RECT, 0f, 0f, m_MenuWidth, m_MenuHeight)));
        m_MenuBackground.GetShape().setFill(m_MenuBackgroundColor);



        // Set position of menu
        transform().SetPosition(m_MenuPosition);
    }

    // If an animal was clicked on, then show the control display
    public void OnColliderClick(Collider collider)
    {
        // Check if it's an animal that was clicked on
        if (collider.GetGameObject() instanceof Animal)
        {
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