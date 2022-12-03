public class DebugColliderTreeObject extends GameObject
{
    public DebugColliderTreeObject()
    {
        super("Debug Collider Tree Object");
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        // Create behaviour to this object
        AddComponent(new DebugColliderTree());
    }
}

public class DebugColliderTree extends Component
{
    /* Members. */
    private ZVector m_RangePos = new ZVector();
    private ZVector m_RangeSize = new ZVector(600f, 600f);
    private float m_MoveSpeed = 5f;
    
    @Override
    public void LateUpdate()
    {
        if (InputManager.GetInstance().GetKey('c'))
        {
            // Get collider tree
            QuadTree<Collider> colliderTree = m_GameObject.GetBelongingToScene().GetPhysicsSystem().GetColliderTree();

            // Create test range based on input
            if (InputManager.GetInstance().GetKey(37))
                m_RangePos.add(new ZVector(-1f, 0f).mult(m_MoveSpeed));
            if (InputManager.GetInstance().GetKey(38))
                m_RangePos.add(new ZVector(0f, -1f).mult(m_MoveSpeed));
            if (InputManager.GetInstance().GetKey(39))
                m_RangePos.add(new ZVector(1f, 0f).mult(m_MoveSpeed));
            if (InputManager.GetInstance().GetKey(40))
                m_RangePos.add(new ZVector(0f, 1f).mult(m_MoveSpeed));

            QuadRect range = new QuadRect(m_RangePos, m_RangeSize);

            // Draw range
            noFill();
            rect(range.pos.x, range.pos.y, range.size.x, range.size.y);
            fill(255);

            // Query the tree for the points in the range
            ArrayList<QuadPoint<Collider>> points = colliderTree.Query(range, new ArrayList<QuadPoint<Collider>>());

            // Higlight points
            for (int i = 0; i < points.size(); i++)
            {
                QuadPoint<Collider> point = points.get(i); 
                fill(255, 0, 0);
                circle(point.pos.x, point.pos.y, 50f);
            }
        }

        
    }
}