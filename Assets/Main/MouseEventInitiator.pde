/*
 * Mouse Event Initiator prefab creates a GameObject which will trigger
 * all subscribed responders to the IMouseEventListener event.
*/
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

    private float m_CurrentMouseDragTime = 0f; // Duration the mouse has been held down
    private float m_NeededMouseDragTime = 0.1f; // Amount of time the mouse should be held down before it's seen as dragging the mouse

    /* Getters/Setters. */
    public void AddMouseEventListener(IMouseEventListener listener) { m_MouseEventListeners.add(listener); }

    public MouseEventInitiator()
    {
        m_Name = "Mouse Event Initiator Behaviour";
    }

    @Override
    public void Start()
    {
        m_PhysicsSystem = m_GameObject.GetBelongingToScene().GetPhysicsSystem();
    }

    @Override
    public void Update()
    {
        boolean mouseClicked = InputManager.GetInstance().IsLeftMousePressed();
        ZVector mouseCords = new ZVector(mouseX, mouseY);
        
        // Mouse being dragged
        if (mouseClicked && m_MouseClickedLastFrame)
        {
            m_CurrentMouseDragTime += Time.dt();
            if (m_CurrentMouseDragTime < m_NeededMouseDragTime)
                return;
            
            // Trigger mouse drag event when the mouse has been held down for long enough
            for (int i = 0; i < m_MouseEventListeners.size(); i++)
            {
                m_MouseEventListeners.get(i).OnMouseDrag(mouseCords);
            }
            return;
        }
        else
        {
            m_CurrentMouseDragTime = 0f; // reset drag time because of mouse release
        }

        // Mouse only being pressed
        if (mouseClicked && !m_MouseClickedLastFrame)
        {
            println("mouse clicked at: " + mouseCords);
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