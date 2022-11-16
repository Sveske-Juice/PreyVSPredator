public abstract class Collider extends Component implements OnCollisionEnterListener
{
    /* Members. */
    protected color m_OnCollisionColor = color(255, 0, 0);
    protected boolean m_IsStatic = true;
    private ArrayList<OnCollisionEnterListener> m_OnCollisionEnterListeners = new ArrayList<OnCollisionEnterListener>();

    public Collider(String name)
    {
        m_Name = name;
    }
    
    /* Methods. */
    @Override
    public void Start()
    {
        m_GameObject.GetBelongingToScene().GetCollissionSystem().RegisterCollider(this);
        AddOnCollisionEnterListener(this);
    }

    @Override
    public void Update()
    {
        DrawCollider();
        //println(m_OnCollisionEnterListeners.size());
    }

    public abstract boolean PointInCollider(PVector point);
    public abstract void CollideAgainstCircle(CircleCollider collider);
    public abstract void CollideAgainstBox(BoxCollider collider);
    public abstract void DrawCollider();
    public abstract void ResolveCollision(CollisionInfo collisionInfo);

    /// Adds a event listener to the listener pool
    public void AddOnCollisionEnterListener(OnCollisionEnterListener listener)
    {
        if (listener == null)
            return;
        
        m_OnCollisionEnterListeners.add(listener);
    }

    /// Loops thorugh all On Collision Enter listeneres
    /// and invokes them with the collider collided with
    protected void RaiseOnCollisionEnterEvent(CollisionInfo collisionInfo)
    {
        println("Raising On Collision Enter event... " + m_OnCollisionEnterListeners.size());
        for (int i = 0; i < m_OnCollisionEnterListeners.size(); i++)
        {
            m_OnCollisionEnterListeners.get(i).OnCollisionEnter(collisionInfo);
        }
    }

    public void OnCollisionEnter(CollisionInfo collisionInfo)
    {
        println("COLLISION DETECTED");
        ResolveCollision(collisionInfo);
    }
}