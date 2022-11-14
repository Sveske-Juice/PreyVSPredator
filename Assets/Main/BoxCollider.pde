public class BoxCollider extends Collider
{
    /* Members. */
    private float m_Width = 100f;
    private float m_Height = 100f;

    /* Getters/Setters. */
    public float GetWidth() { return m_Width; }
    public float GetHeight() { return m_Height; }
    public PVector GetCenter() { return new PVector(m_GameObject.GetTransform().Position.x + m_Width / 2f, m_GameObject.GetTransform().Position.y + m_Height / 2f); }

    public BoxCollider()
    {
        super("Box Collider");
    }

    @Override
    public boolean PointInCollider(PVector point)
    {
        return (    point.x > m_GameObject.GetTransform().Position.x && point.x < m_GameObject.GetTransform().Position.x + m_Width &&
                    point.y > m_GameObject.GetTransform().Position.y && point.y < m_GameObject.GetTransform().Position.y + m_Height);
    }

    @Override
    public void CollideAgainstCircle(CircleCollider collider)
    {

    }

    @Override
    public void CollideAgainstBox(BoxCollider collider)
    {
        PVector ourPosition = m_GameObject.GetTransform().Position;
        PVector checkPosition = collider.GetGameObject().GetTransform().Position;
        float checkWidth = collider.GetWidth();
        float checkHeight = collider.GetHeight();

        if (    ourPosition.x < checkPosition.x + checkWidth && ourPosition.x + m_Width > checkPosition.x &&
                ourPosition.y < checkPosition.y + checkHeight && ourPosition.y + m_Height > checkPosition.y)
        {
            println("Collision!!");
            fill(255, 0, 0);
        }
        fill(255);
    }

    @Override
    public void DrawCollider()
    {
        rect(m_GameObject.GetTransform().Position.x, m_GameObject.GetTransform().Position.y, m_Width, m_Height);
    }
}