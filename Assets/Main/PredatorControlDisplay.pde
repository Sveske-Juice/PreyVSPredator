/*
 * Prefab for creating the prey control display when clicking on a prey
*/
public class PredatorControlDisplayObject extends GameObject
{
    public PredatorControlDisplayObject()
    {
        super("Predator Control Display");
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        AddComponent(new PredatorControlDisplay());
    }
}

/*
 * Behaviour class. Will handle displaying the prey control display when clicking on a prey.
*/
public class PredatorControlDisplay extends AnimalControlDisplay implements IMouseEventListener
{
    /* Members. */
    private Text m_PreysEaten;
    private Text m_StateText;
    private PredatorController m_PredatorController;

    public PredatorControlDisplay()
    {
        super("Predator Control Display");
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

        if (m_ConnectedAnimal.GetTag() != "Predator")
            return;

        m_PredatorController = m_ConnectedAnimal.GetComponent(PredatorController.class);

        m_PreysEaten.SetText("Preys eaten: " + m_PredatorController.GetPreysEaten());
        m_StateText.SetText("State: " + m_PredatorController.GetState());
    }

    /* Prey specific menu attributes. */
    @Override
    protected void CreateMenu()
    {
        super.CreateMenu();

        if (m_ConnectedAnimal.GetTag() != "Predator")
            return;


        // Create state text
        GameObject stateTxtObj = m_Scene.AddGameObject(new UIElement("Predator State Text Object"), m_MenuBackground.transform());
        stateTxtObj.SetTag("AnimalControlDisplay");
        m_StateText = (Text) stateTxtObj.AddComponent(new Text("Predator State Text"));
        m_StateText.SetMargin(new ZVector(25f, 25f));
        m_StateText.transform().SetLocalPosition(new ZVector(0f, 150f));

        // Create preys nearby element
        GameObject eatenPreysObj = m_Scene.AddGameObject(new UIElement("Predator Eaten Preys Text Object"), m_MenuBackground.transform());
        eatenPreysObj.SetTag("AnimalControlDisplay");
        m_PreysEaten = (Text) eatenPreysObj.AddComponent(new Text("Predator Eaten Preys Text"));
        m_PreysEaten.SetMargin(new ZVector(25f, 25f));
        m_PreysEaten.transform().SetLocalPosition(new ZVector(0f, 200f));      
    }

    /*
     * Gets called when the mouse is clicked on a collider.
     * Will handle showing the menu if a predator was clicked on.
    */
    @Override
    public void OnColliderClick(Collider collider)
    {
        // Check if it's a predator that was clicked on
        if (collider.GetGameObject() instanceof Predator)
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