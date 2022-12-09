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
    private Progressbar m_NutrientsBar;
    private color m_NutrientsBarColor = color(255, 220, 85);
    private PredatorController m_PredatorController;

    public PredatorControlDisplay()
    {
        super("Predator Control Display");
    }

    @Override
    public void Start()
    {
        super.Start();

        m_GameScene.FindGameObject("Mouse Event Initiator Handler").GetComponent(MouseEventInitiator.class).AddMouseEventListener(this);
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
        m_NutrientsBar.SetProgress(m_PredatorController.GetNutrients() / m_PredatorController.GetMaxNutrients());
    }

    /* Prey specific menu attributes. */
    @Override
    protected void CreateMenu()
    {
        super.CreateMenu();

        if (m_ConnectedAnimal.GetTag() != "Predator")
            return;


        // Create state text
        GameObject stateTxtObj = m_GameScene.AddGameObject(new UIElement("Predator State Text Object"), m_MenuBackground.transform());
        stateTxtObj.SetTag("AnimalControlDisplay");
        m_StateText = (Text) stateTxtObj.AddComponent(new Text("Predator State Text"));
        m_StateText.SetMargin(new ZVector(25f, 25f));
        m_StateText.transform().SetLocalPosition(new ZVector(0f, 350f));

        // Create preys nearby element
        GameObject eatenPreysObj = m_GameScene.AddGameObject(new UIElement("Predator Eaten Preys Text Object"), m_MenuBackground.transform());
        eatenPreysObj.SetTag("AnimalControlDisplay");
        m_PreysEaten = (Text) eatenPreysObj.AddComponent(new Text("Predator Eaten Preys Text"));
        m_PreysEaten.SetMargin(new ZVector(25f, 25f));
        m_PreysEaten.transform().SetLocalPosition(new ZVector(0f, 400f));
        
        // Create nutrients bar title
        GameObject nutrientsTitleObj = m_GameScene.AddGameObject(new UIElement("Nutrients Title Object"), m_MenuBackground.transform());
        nutrientsTitleObj.SetTag("AnimalControlDisplay");
        Text nutrientsTitle = (Text) nutrientsTitleObj.AddComponent(new Text("Nutrients Title"));
        nutrientsTitle.SetText("Nutrients: ");
        nutrientsTitle.SetMargin(new ZVector(25f, 25f));
        nutrientsTitle.transform().SetLocalPosition(new ZVector(0f, 450f));

        // Create Nutrients progress bar
        GameObject nutrientsBarObj =  m_GameScene.AddGameObject(new UIElement("Nutrients Progressbar Object"), m_MenuBackground.transform());
        nutrientsBarObj.SetTag("AnimalControlDisplay");
        m_NutrientsBar = (Progressbar) nutrientsBarObj.AddComponent(new Progressbar("Nutrients Progressbar"));
        m_NutrientsBar.SetMargin(new ZVector(25f, 25f));
        m_NutrientsBar.SetSize(new ZVector(m_MenuWidth - 100f, 50f));
        m_NutrientsBar.SetProgressColor(m_NutrientsBarColor);
        m_NutrientsBar.transform().SetLocalPosition(new ZVector(0f, 490f)); 
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