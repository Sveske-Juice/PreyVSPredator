public class Polygon extends Component
{
    /* Members. */
    private PShape m_PShape;
    private boolean m_DrawShape = true;
    private float m_RotationOffset = 0f;
    private ZVector m_PositionOffset = new ZVector();

    /* Getters/Setters. */
    public boolean IsDrawingShape() { return m_DrawShape; }
    public void SetDrawingShape(boolean enabled) { m_DrawShape = enabled; }
    public void SetShape(PShape shape) { m_PShape = shape; }
    public PShape GetShape() { return m_PShape; }
    public void SetRotationOffset(float value) { m_RotationOffset = value; }

    public Polygon()
    {
        m_Name = "Polygon";
    }

    public Polygon(PShape shape)
    {
        m_PShape = shape;
        m_Name = "Polygon";
    }

    public Polygon(PShape shape, ZVector offset)
    {
        m_PShape = shape;
        m_Name = "Polygon";
        m_PositionOffset = offset;
    }

    /* Methods. */
    @Override
    public void LateUpdate()
    {
        if (!m_DrawShape || m_PShape == null)
            return;
        
        Display();
    }

    private void Display()
    {
        ZVector pos = transform().GetPosition();
        
        // Create new transformation matrix for displaying the polygon
        pushMatrix();
        
        // Translate the coordinate system so the polygon to draw is in center
        translate(pos.x + m_PositionOffset.x, pos.y + m_PositionOffset.y);
        rotate(m_GameObject.GetTransform().GetRotation() + m_RotationOffset);

        // Draw from center
        shapeMode(CENTER);

        // Draw the polygon
        shape(m_PShape);

        // Restore the old coordinate system for the next draw call
        // by popping the newly created transformation matrix from the matrix stack
        popMatrix();
    }
}