public class Polygon extends Component
{
    /* Members. */
    private PShape m_PShape;
    private boolean m_DrawShape = true;

    /* Getters/Setters. */
    public boolean IsDrawingShape() { return m_DrawShape; }
    public void SetDrawingShape(boolean enabled) { m_DrawShape = enabled; }
    public void SetShape(PShape shape) { m_PShape = shape; }

    public Polygon()
    {
        m_Name = "Polygon";
    }

    public Polygon(PShape shape)
    {
        m_PShape = shape;
        m_Name = "Polygon";
    }

    /* Methods. */
    @Override
    public void Update()
    {
        if (!m_DrawShape || m_PShape == null)
            return;
        
        Display();
    }

    private void Display()
    {
        PVector pos = transform().GetPosition();
        
        // Create new transformation matrix for displaying the polygon
        pushMatrix();
        
        // Translate the coordinate system so the polygon to draw is in center
        translate(pos.x, pos.y);

        // Draw the polygon
        shape(m_PShape);

        // Restore the old coordinate system for the next draw call
        // by popping the newly created transformation matrix from the matrix stack
        popMatrix();
    }
}