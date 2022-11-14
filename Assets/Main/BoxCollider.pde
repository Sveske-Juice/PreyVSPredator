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
    public boolean PointInCollider(PVector point)
    {
        return (    point.x > transform().Position.x && point.x < transform().Position.x + m_Width &&
                    point.y > transform().Position.y && point.y < transform().Position.y + m_Height);
    }

    @Override
    public void CollideAgainstCircle(CircleCollider collider)
    {
        
        PVector checkPosition = collider.transform().Position;

        PVector circleToBoxDir = PVector.sub(GetCenter(), checkPosition).normalize();

        // Get outer point on circle in the direction of the box to test
        PVector outerPoint = PVector.add(checkPosition, circleToBoxDir.mult(collider.GetRadius()));

        fill(255,0,0);
        circle(outerPoint.x, outerPoint.y, 5);
        fill(255);
        
        println(PointInCollider(outerPoint));
    }

    @Override
    public void CollideAgainstBox(BoxCollider collider)
    {
        PVector ourPosition = transform().Position;
        PVector checkPosition = collider.transform().Position;
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
        println("drawing rect at " + transform().Position + " with width: " + m_Width + " and height: " + m_Height);
        rect(transform().Position.x, transform().Position.y, m_Width, m_Height);
    }
}