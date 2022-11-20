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
        PVector checkPosition = collider.transform().Position;
        PVector checkCenter = collider.GetCenter();
        float checkWidth = collider.GetWidth();
        float checkHeight = collider.GetHeight();

        PVector ABNorm = PVector.sub(checkCenter, transform().Position).normalize();
        //PVector outerPoint = PVector.add(transform().Position, PVector.mult(ABNorm, m_Radius));
        PVector outerPoint = PVector.add(transform().Position, PVector.mult(((RigidBody) m_GameObject.GetComponent(RigidBody.class)).GetVelocity().copy().normalize(), m_Radius));
        println("norm: " + ABNorm);
        println("outerpoint: " + outerPoint);
        fill(255, 0, 0);
        circle(outerPoint.x, outerPoint.y, 10);
        fill(255);
        
        // Check if outerpoint of circle is inside the AABB
        boolean inAABB = collider.PointInRect(outerPoint);
        
        // No collision happened, set HasCollision flag to false.
        if (!inAABB)
            return new CollisionPoint(null, null, null, false);

        println("COOLL");
        PVector A = outerPoint;
        PVector B = new PVector();

        if (ABNorm.x >= 0) // Circle collided from left
        {
            B.x = checkPosition.x;
        }
        else // Circle collided from right
        {
            B.x = checkPosition.x + checkWidth;
        }
        
        if (ABNorm.y >= 0) // Circle collided from top
        {
            B.y = checkPosition.y;
        }
        else // Circle collided from bottom
        {
            B.y = checkPosition.y + checkHeight;
        }

        fill(255, 0, 0);
        circle(A.x, A.y, 10);
        fill(0, 255, 0);
        circle(B.x, B.y, 10);
        fill(255);

        return new CollisionPoint(A, B, ABNorm, true);
    }
}