public class BoxCollider extends Collider
{
    /* Members. */
    private RigidBody m_RigidBody = null;
    private float m_Width = 50f;
    private float m_Height = 50f;

    /* Getters/Setters. */
    public float GetWidth() { return m_Width; }
    public void SetWidth(float width) { m_Width = width; }
    public float GetHeight() { return m_Height; }
    public void SetHeight(float height) { m_Height = height; }
    public PVector GetCenter() { return new PVector(transform().Position.x + m_Width / 2f, transform().Position.y + m_Height / 2f); }

    public BoxCollider(float width, float height)
    {
        super("Box Collider");
        m_Width = width;
        m_Height = height;
    }

    public BoxCollider()
    {
        super("Box Collider");
    }

    @Override
    public void Start()
    {
        super.Start();

        m_RigidBody = m_GameObject.GetComponent(RigidBody.class);
    }

    @Override
    public void DrawCollider()
    {
        rect(transform().Position.x, transform().Position.y, m_Width, m_Height);
    }

    public boolean PointInRect(PVector point)
    {
        if (point == null) return false;

        PVector pos = transform().Position; // Cache pos
        return (    point.x > pos.x && point.x < pos.x + m_Width &&
                    point.y > pos.y && point.y < pos.y + m_Height);
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
        // Use circle collider's implementation
        return collider.TestCollision(this);
    }

    @Override
    public CollisionPoint TestCollision(BoxCollider collider)
    {

        PVector Ap = transform().Position; // Position of collider A
        PVector Bp = collider.transform().Position; // Position of collider B

        PVector Av = m_RigidBody.GetVelocity(); // Velocity of rigidbody of collider A

        float xInvEntry = 0f;
        float xInvExit = 0f;
        
        float yInvEntry = 0f;
        float yInvExit = 0f;

        if (Av.x > 0f)
        {
            xInvEntry = Bp.x - (Ap.x + m_Width);
            xInvExit = (Bp.x + collider.GetWidth()) - Ap.x;
        }
        else
        {
            xInvEntry = (Bp.x + collider.GetWidth()) - Ap.x;
            xInvExit = Bp.x - (Ap.x + m_Width);
        }

        if (Av.y > 0f)
        {
            yInvEntry = Bp.y - (Ap.y + m_Height);
            yInvExit = (Bp.y + collider.GetHeight()) - Ap.y;
        }
        else
        {
            yInvEntry = (Bp.y + collider.GetHeight()) - Ap.y;
            yInvExit = Bp.y - (Ap.y + m_Height);
        }

        // Find interpolated time where the collision and time of leaving for each axis
        float xEntry = 0f;
        float xExit = 0f;

        float yEntry = 0f;
        float yExit = 0f;

        if (Av.x == 0f) // Prevent divison by 0
        {
            xEntry = 9999f;
            xExit = -9999f;
        }
        else
        {
            xEntry = xInvEntry / Av.x;
            xExit = xInvExit / Av.x;
        }

        if (Av.y == 0f) // Prevent division by 0
        {
            yEntry = 9999f;
            yExit = -9999f;
        }
        else
        {
            yEntry = yInvEntry / Av.y;
            yExit = yInvExit / Av.y;
        }

        // Find what axis collided first
        float entryTime = max(xEntry, yEntry);
        float exitTime = min(xExit, yExit);

        println("A Vel: " + Av);
        println("entry: " + entryTime);
        println("exit: " + exitTime);
        // If there was no collision
        
        /*
        if (entryTime > exitTime || xEntry < 0f && yEntry < 0f || xEntry > 1f || yEntry > 1f)
        {
            // No collision happened set HasCollision flag to false.
            return new CollisionPoint(null, null, null, false);
        }
        */


        // Double check collision with AABB collision check
        if ((   Ap.x + m_Width > Bp.x && Ap.x < Bp.x + collider.GetWidth() &&
                Ap.y + m_Height > Bp.y && Ap.y < Bp.y + collider.GetHeight()) == false)
        {
            println("No collision");
            return new CollisionPoint(null, null, null, false);
        }

        // Collision happened
        println("Collision!!!");

        // Calculate normal of the collision surface
        PVector normal = new PVector();

        if (xEntry > yEntry) 
        { 
            if (xInvEntry < 0f) 
            { 
                normal.x = 1f; 
                normal.y = 0f; 
            } 
            else 
            { 
                normal.x = -1f; 
                normal.y = 0f;
            } 
        } 
        else 
        { 
            if (yInvEntry < 0f) 
            { 
                normal.x = 0f; 
                normal.y = 1f; 
            } 
            else 
            { 
                normal.x = 0f; 
                normal.y = -1f; 
            } 
        }

        RigidBody Bbody = collider.GetGameObject().GetComponent(RigidBody.class);

        println("normal: " + normal);


        PVector impulse = PVector.mult(normal, PVector.dot(Av, normal) * -1f);
        //PVector ARes = PVector.mult(normal.copy().rotate(PI), m_RigidBody.GetVelocity().mag() / 2f);
        //PVector BRes = PVector.mult(normal, Bbody.GetVelocity().mag() / 2f);

        m_RigidBody.SetVelocity(PVector.add(m_RigidBody.GetVelocity(), impulse));
        //Bbody.SetVelocity(BRes);
        //PVector resolution = PVector.mult(m_RigidBody.GetVelocity(), entryTime);
        //PVector resolution = PVector.mult(normal, 0.5f);
        //collider.transform().Position = (PVector.mult(resolution, -1f));
        //transform().Position = (resolution);
        

        //transform().Position.add(PVector.div(resolution, 2f));
        //collider.transform().Position.add(PVector.div(PVector.mult(resolution, -1f), 2f));

        return new CollisionPoint(null, null, null, false);
    }
}