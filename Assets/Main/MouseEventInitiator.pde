// Mouse Event Initiator prefab creates a GameObject which will trigger
// all subscribed responders to the IMouseEventListener event.
public class MouseEventInitiatorObject extends GameObject
{
    public MouseEventInitiatorObject()
    {
        super("Mouse Event Initiator Handler");
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        // Create behaviour to this object
        AddComponent(new MouseEventInitiator());
    }
}

public class MouseEventInitiator extends Component
{
    /* Members. */
    private ArrayList<IMouseEventListener> m_MouseEventListeners = new ArrayList<IMouseEventListener>();
    private PhysicsSystem m_PhysicsSystem;
    private boolean m_MouseClickedLastFrame;

    /* Getters/Setters. */
    public void AddMouseEventListener(IMouseEventListener listener) { m_MouseEventListeners.add(listener); }

    @Override
    public void Start()
    {
        m_PhysicsSystem = m_GameObject.GetBelongingToScene().GetPhysicsSystem();
    }

    @Override
    public void Update()
    {
        boolean mouseClicked = InputManager.GetInstance().IsLeftMousePressed();
        PVector mouseCords = new PVector(mouseX, mouseY);
        
        // Mouse being dragged
        if (mouseClicked && m_MouseClickedLastFrame)
        {
            for (int i = 0; i < m_MouseEventListeners.size(); i++)
            {
                m_MouseEventListeners.get(i).OnMouseDrag(mouseCords);
            }
            return;
        }

        // Mouse only being pressed
        if (mouseClicked && !m_MouseClickedLastFrame)
        {
            for (int i = 0; i < m_MouseEventListeners.size(); i++)
            {
                m_MouseEventListeners.get(i).OnMouseClick(mouseCords);
            }
        }
        else
        {
            // Mouse being released
            for (int i = 0; i < m_MouseEventListeners.size(); i++)
            {
                m_MouseEventListeners.get(i).OnMouseRelease(mouseCords);
            }
        }
        m_MouseClickedLastFrame = mouseClicked;

        if (!mouseClicked)
            return;
        
        // Make a point overlap to see if there's a collider under the mouse
        Collider hitCollider = m_PhysicsSystem.PointOverlap(mouseCords, true);

        if (hitCollider == null)
            return;

        for (int i = 0; i < m_MouseEventListeners.size(); i++)
        {
            m_MouseEventListeners.get(i).OnColliderClick(hitCollider);
        }

    }
}