public class BoxCollider extends Collider
{
    /* Members. */
    private RigidBody m_RigidBody = null;
    private float m_Width = 50f;
    private float m_Height = 50f;
    private ZVector m_Extents = new ZVector(m_Width, m_Height);

    /* Getters/Setters. */
    public float GetWidth() { return m_Width; }
    public void SetWidth(float width) { m_Width = width; m_Extents = new ZVector(m_Width, m_Height); }
    public float GetHeight() { return m_Height; }
    public void SetHeight(float height) { m_Height = height; m_Extents = new ZVector(m_Width, m_Height); }

    @Override
    public ZVector GetCenter() { return new ZVector(transform().GetPosition().x + m_Width / 2f, transform().GetPosition().y + m_Height / 2f); }

    public BoxCollider(float width, float height)
    {
        super("Box Collider");
        m_Width = width;
        m_Height = height;
        m_Extents = new ZVector(width, height);
    }

    public BoxCollider()
    {
        super("Box Collider");
    }

    public BoxCollider(String name)
    {
        super(name);
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
        rect(transform().GetPosition().x, transform().GetPosition().y, m_Width, m_Height);

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
        ZVector pos = transform().GetPosition(); // cache pos
        float epsilon = 1e-8;
        ZVector colVel = collider.GetGameObject().GetComponent(RigidBody.class).GetVelocity();
        ZVector boxPos = collider.transform().GetPosition(); // Cache pos
        ZVector deltaPos = ZVector.sub(pos, ZVector.add(pos, colVel));
        Hit hit = IntersectSegment(boxPos, deltaPos, new ZVector(collider.GetWidth() / 2f, collider.GetHeight() / 2f));
        if (hit != null)
        {
            float sweepTime = Clamp(hit.hitTime - epsilon, 0, 1);

            // println("sweep time: " + sweepTime);
            // println("hit time: " + hit.hitTime);

            ZVector sweepPos = new ZVector();
            sweepPos.x = (boxPos.x + deltaPos.x) * sweepTime;
            sweepPos.y = (boxPos.y + deltaPos.y) * sweepTime;

            ZVector dir = deltaPos.copy().normalize();
            // fill(255, 0, 0);
            // circle(hit.hitPoint.x, hit.hitPoint.y, 15);
            //hit.hitPoint.x = Clamp(hit.hitPoint.x + dir.x * collider.GetWidth() / 2f, pos.x - m_Width, pos.x + m_Width);
            //hit.hitPoint.y = Clamp(hit.hitPoint.y + dir.y * collider.GetHeight() / 2f, pos.y - m_Height, pos.y + m_Height);

            // println("dir: " + dir);
            // println("sweep pos: " + sweepPos);

            // fill(255, 0, 0);
            // circle(hit.hitPoint.x, hit.hitPoint.y, 15);
            // circle(sweepPos.x, sweepPos.y, 15);
            // fill(255);

            // Resolve collision inside detection function
            // TODO move this to resovle func
            m_RigidBody.SetVelocity(sweepPos);
        }

        // No collision happened
        return null;
    }

    public Hit IntersectSegment(ZVector startPt, ZVector deltaPos, ZVector padding)
    {
        ZVector pos = transform().GetPosition(); // Cache pos

        float scaleX = 1f / deltaPos.x;
        float scaleY = 1f / deltaPos.y;

        int signX = Sign(scaleX);
        int signY = Sign(scaleY);
 

        float nearTimeX = (pos.x - signX * (m_Width / 2f + padding.x) - startPt.x) * scaleX;
        float nearTimeY = (pos.y - signY * (m_Height / 2f + padding.y) - startPt.y) * scaleY;

        float farTimeX = (pos.x + signX * (m_Width / 2f + padding.x) - startPt.x) * scaleX;
        float farTimeY = (pos.y + signY * (m_Height / 2f + padding.y) - startPt.y) * scaleY;

        if (nearTimeX > farTimeY || nearTimeY > farTimeX)
        {
            return null;
        }

        float nearTime = nearTimeX > nearTimeY ? nearTimeX : nearTimeY;
        float farTime = farTimeX < farTimeY ? farTimeX : farTimeY;

        if (nearTime >= 1 || farTime <= 0)
        {
            return null;
        }
        // println("delta pos: " + deltaPos);
        // println("near x: " + nearTimeX);
        // println("near y: " + nearTimeY);
        // println("sign x: " + signX);
        // println("sign y: " + signY);
        float hitTime = Clamp(nearTime, 0, 1);
        ZVector normal = new ZVector();
        if (nearTimeX > nearTimeY)
        {
            normal.x = -signX;
        }
        else
        {
            normal.y = -signY;
        }

        

        ZVector penetration = new ZVector();

        penetration.x = (1f - hitTime) * -deltaPos.x;
        penetration.y = (1f - hitTime) * -deltaPos.y;

        ZVector hitPoint = new ZVector();

        hitPoint.x = startPt.x + deltaPos.x * hitTime;
        hitPoint.y = startPt.y + deltaPos.y * hitTime;

        // Create hit structure
        Hit hit = new Hit(this);
        hit.hitPoint = hitPoint;
        hit.penetration = penetration;
        hit.normal = normal;
        hit.hitTime = hitTime;

        // println("normal: " + normal);
        // println("hit point: " + hitPoint);
        // println("penetration: " + penetration);
        return hit;
    }
    
    @Override
    public RaycastHit TestRaycast(Ray ray)
    {
        return new RaycastHit(null, null, -1f, false);
    }

    @Override
    public boolean PointInCollider(ZVector point)
    {
        // TODO implement fixed collider check
        if (point == null) return false;

        ZVector pos = transform().GetPosition(); // Cache pos
        return (    point.x > pos.x && point.x < pos.x + m_Width &&
                    point.y > pos.y && point.y < pos.y + m_Height);
    }
    

    @Override
    public ZVector GetMinExtents()
    {
        // TODO take offset into account here
        return transform().GetPosition();
    }

    @Override
    public ZVector GetMaxExtents()
    {
        // TODO take offset into account here
        return ZVector.add(transform().GetPosition(), m_Extents);
    }

    private int Sign(float x)
    {
        if (x < 0) return -1;
        else if (x > 0) return 1;
        return 0;
    }
}