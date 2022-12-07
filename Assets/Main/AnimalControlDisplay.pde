// Base behaviour class for displaying control side menu on any animal
public class AnimalControlDisplay extends Component implements IAnimalEventListener
{
    /* Members. */
    protected Scene m_Scene;
    protected ZVector m_MenuPosition = new ZVector(10f, 10f);

    protected float m_MenuWidth = 600f;
    protected float m_MenuHeight;
    protected color m_MenuBackgroundColor = color(12, 32, 51, 220);

    protected boolean m_MenuBeingShowed = false;
    protected Animal m_ConnectedAnimal; // Animal showing stats about
    protected AnimalMover m_ConnectedAnimalMover;

    protected Polygon m_MenuBackground;
    protected Button m_TakeControlButton;
    protected Text m_PositionText;
    protected Text m_SpeedText;
    protected Slider m_MassSlider;
    private TakeControl m_TakeControl;

    public AnimalControlDisplay(String name)
    {
        m_Name = name;
    }

    public AnimalControlDisplay()
    {
        m_Name = "Animal Control Display";
    }

    @Override
    public void Start()
    {
        m_MenuHeight = height - m_MenuPosition.y * 4; // Use Start() since "height" is initialized here

        m_Scene = m_GameObject.GetBelongingToScene();

        // Register this class to get events about animals (deaths etc.)
        m_Scene.FindGameObject("Animal Event Initiator Handler").GetComponent(AnimalEventInitiator.class).RegisterListener(this);
    }

    @Override
    public void Update()
    {
        if (!m_MenuBeingShowed)
            return;

        // Update values on menu
        m_PositionText.SetText("Animal Position: " + m_ConnectedAnimal.GetTransform().GetPosition());
        m_SpeedText.SetText("Speed: " + round(m_ConnectedAnimalMover.GetGameObject().GetComponent(RigidBody.class).GetVelocity().mag()));
        println("mass: " + m_MassSlider.GetCurrentValue());
    }

    protected void ShowMenu(Animal animal)
    {
        // If already open then close it
        if (m_MenuBeingShowed)
        {
            HideMenu();
            return;
        }

        m_ConnectedAnimal = animal;
        m_TakeControl = new TakeControl(m_ConnectedAnimal);
        m_ConnectedAnimalMover = animal.GetComponent(AnimalMover.class);
        
        // Show the animal's view range (perimeter)
        m_ConnectedAnimal.GetTransform().GetChild(0).GetGameObject().GetComponent(Collider.class).SetShouldDraw(true);
        CreateMenu();
        m_MenuBeingShowed = true;
    }

    protected void HideMenu()
    {
        if (m_MenuBackground != null)
            m_MenuBackground.GetGameObject().Destroy();

        if (m_ConnectedAnimal == null)
            return;
        
        // Hide the animal's view range
        m_ConnectedAnimal.GetTransform().GetChild(0).GetGameObject().GetComponent(Collider.class).SetShouldDraw(false);

        // Remove the input controller from the animal if one was added
        m_ConnectedAnimal.RemoveComponent(AnimalInputController.class);

        // Hide the animals wandering info
        m_ConnectedAnimalMover.HideWanderInfo();

        // TODO refactor this
        PreyController prey = m_ConnectedAnimal.GetComponent(PreyController.class);
        PredatorController predator = m_ConnectedAnimal.GetComponent(PredatorController.class);
        
        if (prey != null)
            prey.SetState(PreyState.WANDERING);
        else if (predator != null)
            predator.SetState(PredatorState.WANDERING, true);

        m_MenuBeingShowed = false;
        m_ConnectedAnimal = null;
        m_ConnectedAnimalMover = null;
    }

    protected void CreateMenu()
    {
        // Set position of menu
        transform().SetPosition(m_MenuPosition);

        // Show the animals wandering info
        m_ConnectedAnimalMover.ShowWanderInfo();

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
        m_PositionText = (Text) positionTextObj.AddComponent(new Text("Position Text"));
        m_PositionText.SetMargin(new ZVector(25f, 25f));
        m_PositionText.transform().SetLocalPosition(new ZVector(0f, 50f));

        // Create speed text element
        GameObject speedTxtObj = m_Scene.AddGameObject(new UIElement("Speed Text Object"), menuBackground.GetTransform());
        speedTxtObj.SetTag("AnimalControlDisplay");
        m_SpeedText = (Text) speedTxtObj.AddComponent(new Text("Speed Text"));
        m_SpeedText.SetMargin(new ZVector(25f, 25f));
        m_SpeedText.transform().SetLocalPosition(new ZVector(0f, 100f));

        // Mass slider
        SliderObject massSliderObj = (SliderObject) m_Scene.AddGameObject(new SliderObject(), menuBackground.GetTransform());
        m_MassSlider = massSliderObj.GetComponent(Slider.class);
        m_MassSlider.SetMargin(new ZVector(25f, 25f));
        m_MassSlider.transform().SetLocalPosition(new ZVector(0f, 200f));
        
        // Take control button
        m_TakeControlButton = (Button) m_Scene.AddGameObject(new Button("Take Control Button Object"), menuBackground.GetTransform());
        ButtonBehaviour btnBeh = m_TakeControlButton.GetComponent(ButtonBehaviour.class);
        m_TakeControlButton.SetTag("AnimalControlDisplay");
        btnBeh.SetSize(new ZVector(300f, 100f));
        m_TakeControlButton.GetTransform().SetLocalPosition(new ZVector(m_MenuWidth / 2f - btnBeh.GetSize().x / 2f, 750f));
        btnBeh.SetText("Control Animal");
        btnBeh.AddButtonListener(m_TakeControl); // Add callback to button
    }

    @Override
    public void OnAnimalDeath(Animal animal, int animalId)
    {
        if (!m_MenuBeingShowed)
            return;

        // Check if the animal that died is the same as the one being displayed info about
        if (m_ConnectedAnimal.GetId() == animalId)
            HideMenu();
    }
}

/*
 * Behaviour for take control button. Handles logic when the button is pressed.
*/
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

        // TODO refactor this
        // Set state of animal to possesed (won't wander)
        PreyController prey = m_Animal.GetComponent(PreyController.class);
        PredatorController predator = m_Animal.GetComponent(PredatorController.class);

        if (prey != null)
            prey.SetState(PreyState.POSSESED);
        else if (predator != null)
            predator.SetState(PredatorState.POSSESED);
            
    }
}