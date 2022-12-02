// Base behaviour class for displaying control side menu on any animal
public class AnimalControlDisplay extends Component implements IMouseEventListener
{
    /* Members. */
    protected Scene m_Scene;
    protected ZVector m_MenuPosition = new ZVector(10f, 10f);

    protected float m_MenuWidth = 600f;
    protected float m_MenuHeight;
    protected color m_MenuBackgroundColor = color(12, 32, 51, 220);

    protected boolean m_MenuBeingShowed = false;
    protected Animal m_ConnectedAnimal; // Animal showing stats about

    protected Polygon m_MenuBackground;
    protected Button m_TakeControlButton;
    protected Text m_PositionText;
    private TakeControl m_TakeControl;


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

    private void ShowMenu(Animal animal)
    {
        // If already open then close it
        if (m_MenuBeingShowed)
        {
            HideMenu();
            return;
        }

        m_ConnectedAnimal = animal;
        m_TakeControl = new TakeControl(m_ConnectedAnimal);
        
        // Show the animal's view range (perimeter)
        m_ConnectedAnimal.GetTransform().GetChild(0).GetGameObject().GetComponent(Collider.class).SetShouldDraw(true);
            
        CreateMenu();
        m_MenuBeingShowed = true;
    }

    private void HideMenu()
    {
        // println("Hiding menu");

        m_MenuBackground.GetGameObject().Destroy();

        // Hide the animal's view range
        m_ConnectedAnimal.GetTransform().GetChild(0).GetGameObject().GetComponent(Collider.class).SetShouldDraw(false);

        // Remove the input controller from the animal if one was added
        m_ConnectedAnimal.RemoveComponent(AnimalInputController.class);

        m_MenuBeingShowed = false;
        m_ConnectedAnimal = null;
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
        statTitleTxt.SetMargin(new ZVector(25f, 25f));

        // Create position text element
        GameObject positionTextObj = m_Scene.AddGameObject(new UIElement("Position Text Object"), menuBackground.GetTransform());
        positionTextObj.SetTag("AnimalControlDisplay");
        m_PositionText = (Text) positionTextObj.AddComponent(new Text("Position text"));
        m_PositionText.SetMargin(new ZVector(25f, 25f));
        m_PositionText.transform().SetLocalPosition(new ZVector(0f, 50f));

        // Take control button
        m_TakeControlButton = (Button) m_Scene.AddGameObject(new Button("Take Control Button Object"), menuBackground.GetTransform());
        ButtonBehaviour btnBeh = m_TakeControlButton.GetComponent(ButtonBehaviour.class);
        m_TakeControlButton.SetTag("AnimalControlDisplay");
        btnBeh.SetSize(new ZVector(300f, 100f));
        m_TakeControlButton.GetTransform().SetLocalPosition(new ZVector(m_MenuWidth / 2f - btnBeh.GetSize().x / 2f, 500f));
        btnBeh.SetText("Control Animal");
        btnBeh.AddButtonListener(m_TakeControl); // Add callback to button
    }

    // If an animal was clicked on, then show the control display
    public void OnColliderClick(Collider collider)
    {
        // Check if it's an animal that was clicked on
        if (collider.GetGameObject() instanceof Animal)
        {
            ShowMenu((Animal) collider.GetGameObject());
            return;
        }
        
        // Hide the menu if the GameObject clicked wasn't connected to the Control Display (outside the side menu)
        if (collider.GetGameObject().GetTag() != "AnimalControlDisplay")
        {
            HideMenu();
            m_TakeControl = null;
        }
    }

    public void OnMouseClick(ZVector position)
    {

    }

    public void OnMouseDrag(ZVector position)
    {
        // TODO Hide the menu if the mouse gets dragged outside the menu
    }

    public void OnMouseRelease(ZVector position)
    {

    }
}

public class TakeControl implements IButtonEventListener
{
    private Animal m_Animal; // Animal to take control of

    public TakeControl(Animal animal)
    {
        m_Animal = animal;
    }

    public void OnClick()
    {

        // If component already on animal then do not add
        if (m_Animal.GetComponent(AnimalInputController.class) != null)
            return;
        
        // println("adding input controller on: " + m_Animal.GetName());
        m_Animal.AddComponent(new AnimalInputController());
    }
}