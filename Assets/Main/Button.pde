public class Button extends UIElement
{
    public Button()
    {
        super("New Button");
    }

    public Button(String name)
    {
        super(name);
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        BoxCollider collider = (BoxCollider) AddComponent(new BoxCollider("Button collider"));
        collider.SetTrigger(true);

        AddComponent(new ButtonBehaviour());
    }
}


public class ButtonBehaviour extends Component implements IMouseEventListener
{
    /* Members. */
    private BoxCollider m_Collider;
    private String m_Text = "Button Text";
    private ArrayList<IButtonEventListener> m_ButtonListeners = new ArrayList<IButtonEventListener>();
    private ZVector m_Size = new ZVector(200f, 50f);
    private ZVector m_Margin = new ZVector();
    private color m_NormalColor = color(38, 50, 74);
    private color m_CurrentColor = m_NormalColor;
    private color m_HighlightColor = color(0, 255, 0);
    private color m_TextColor = color(255, 255, 255);
    private int m_TextSize = 24;
    private float m_ButtonCooldown = 1f;
    private float m_CurrentCooldown = 0f;

    public ButtonBehaviour()
    {
        m_Name = "Button Behaviour";
    }

    public ButtonBehaviour(String name)
    {
        m_Name = name;
    }
    
    /* Getters/Setters. */
    public void SetText(String value) { m_Text = value; }
    public void AddButtonListener(IButtonEventListener listener) { m_ButtonListeners.add(listener); }
    public void SetSize(ZVector size) { m_Size = size; m_Collider.SetWidth(size.x); m_Collider.SetHeight(size.y); }
    public ZVector GetSize() { return m_Size; }

    @Override
    public void Start()
    {
        // Register this class to get mouse events
        m_GameObject.GetBelongingToScene().FindGameObject("Mouse Event Initiator Handler").GetComponent(MouseEventInitiator.class).AddMouseEventListener(this);

        m_Collider = m_GameObject.GetComponent(BoxCollider.class);
        m_Collider.SetCollisionLayer(CollisionLayer.UI_ELEMENT.ordinal());
        m_Collider.SetWidth(m_Size.x);
        m_Collider.SetHeight(m_Size.y);
    }

    @Override
    public void LateUpdate()
    {
        ZVector pos = transform().GetPosition();

        // Draw button
        fill(m_CurrentColor);
        rect(pos.x, pos.y, m_Size.x, m_Size.y);

        // Draw texta
        fill(m_TextColor);
        textAlign(CENTER, CENTER);
        textSize(m_TextSize);
        text(m_Text, pos.x + m_Size.x / 2f, pos.y + m_Size.y / 2f);

        // Reset current button color to normal
        m_CurrentColor = m_NormalColor;

        // Add to the cooldown timer
        m_CurrentCooldown += Time.dt();
    }

    public void OnColliderClick(Collider collider)
    {
        // Check if this button was clicked
        if (m_Collider.GetId() != collider.GetId())
            return;

        // Make sure the cooldown time has gone before triggering again
        if (m_CurrentCooldown < m_ButtonCooldown)
            return;

        RaiseOnClickEvent();

        // Highlight button
        m_CurrentColor = m_HighlightColor;

        // Reset cooldown timer
        m_CurrentCooldown = 0f;
    }

    private void RaiseOnClickEvent()
    {
        println("button clicked, listeners: " + m_ButtonListeners.size());
        for (int i = 0; i < m_ButtonListeners.size(); i++)
        {
            m_ButtonListeners.get(i).OnClick();
        }
    }
    
    public void OnMouseClick(ZVector position) { }
    public void OnMouseDrag(ZVector position) { }
    public void OnMouseRelease(ZVector position) { }
}