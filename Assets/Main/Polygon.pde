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
        PVector pos = m_GameObject.GetTransform().Position;
        translate(pos.x, pos.y);
        shape(m_PShape);
    }

    public PShape CreateRect(PVector position, PVector extents)
    {
        PShape shape = createShape(RECT, position.x, position.y, extents.x, extents.y);
        return shape;
    }
}