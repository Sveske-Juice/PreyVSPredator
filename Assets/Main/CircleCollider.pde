public class CircleCollider extends Collider
{
    /* Members. */
    private PVector m_CenterOffset = new PVector();
    private PVector m_OurPosition;
    private float m_Radius = 30f;

    /* Getters/Setters. */
    public float GetRadius() { return m_Radius; }
    public void SetRadius(float radius) { m_Radius = radius; }

    /* Pass name with initialization. */
    public CircleCollider(String name)
    {
        super(name);
    }

    /* Default constructor. */
    public CircleCollider() { super("Circle Collider"); }

    @Override
    public void Start()
    {
        super.Start();

        // Blue color for static bodies
        if (m_GameObject.GetComponent(RigidBody.class).IsStatic() == true)
        {
            m_ColliderColor = color(0f, 0f, 150f, 75f);
        }
    }

    @Override
    public void DrawCollider()
    {
        circle(transform().Position.x, transform().Position.y, m_Radius*2);
    }

    @Override
    public CollisionPoint TestCollision(Collider collider)
    {
        // Seecond dispatch to reveal concrete class (CircleCollider)
        return collider.TestCollision(this);
    }

    @Override
    public CollisionPoint TestCollision(CircleCollider collider)
    {
        PVector checkPosition = collider.transform().Position;
        float checkRadius = collider.GetRadius();

        float dist = checkPosition.dist(transform().Position); // Dist between centers
        if (dist < m_Radius + checkRadius)
        {
            // They're colliding
            // A is this collider and B is the collider to check
            PVector Normal = PVector.sub(checkPosition, transform().Position).normalize();
            PVector A = PVector.add(transform().Position, PVector.mult(Normal, m_Radius)); // Furthest point of A into B
            PVector B = PVector.add(checkPosition, Normal.copy().rotate(PI).mult(checkRadius));
            return new CollisionPoint(A, B, Normal, true);
        }

        // No collision happened set HasCollision flag to false.
        return new CollisionPoint(null, null, null, false);
    }

    @Override
    public CollisionPoint TestCollision(BoxCollider collider)
    {
        // No collision happened set HasCollision flag to false.
        return new CollisionPoint(null, null, null, false);
    }
}