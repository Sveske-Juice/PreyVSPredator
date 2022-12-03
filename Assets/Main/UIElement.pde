public class UIElement extends GameObject
{
    public UIElement()
    {
        super("New UI Element");

        // By default fix UIElement GameObject's position and scale
        m_FixedPosition = true;
        m_IsUI = true;
    }

    public UIElement(String name)
    {
        super(name);
        
        // By default fix UIElement GameObject's position and scale
        m_FixedPosition = true;
        m_IsUI = true;
    }
}