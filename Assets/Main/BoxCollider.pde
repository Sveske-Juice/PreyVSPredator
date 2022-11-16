public class BoxCollider extends Collider
{
    /* Members. */
    private float m_Width = 50f;
    private float m_Height = 50f;

    /* Getters/Setters. */
    public float GetWidth() { return m_Width; }
    public void SetWidth(float width) { m_Width = width; }
    public float GetHeight() { return m_Height; }
    public void SetHeight(float height) { m_Height = height; }
    public PVector GetCenter() { return new PVector(transform().Position.x + m_Width / 2f, transform().Position.y + m_Height / 2f); }

    public BoxCollider()
    {
        super("Box Collider");
    }

    @Override
    public void DrawCollider()
    {
        rect(transform().Position.x, transform().Position.y, m_Width, m_Height);
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