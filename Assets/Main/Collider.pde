public abstract class Collider extends Component
{
    /* Members. */

    public Collider(String name)
    {
        m_Name = name;
    }
    
    /* Methods. */
    @Override
    public void Start()
    {
        m_GameObject.GetBelongingToScene().GetCollissionSystem().RegisterCollider(this);
    }

    @Override
    public void Update()
    {
        DrawCollider();
    }

    public abstract boolean PointInCollider(PVector point);
    public abstract void CollideAgainstCircle(CircleCollider collider);
    public abstract void CollideAgainstBox(BoxCollider collider);
    public abstract void DrawCollider();
}