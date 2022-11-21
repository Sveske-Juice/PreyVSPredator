public class CameraHandler extends Component
{
    private PVector m_MoveTranslation = new PVector();
    private float m_ScaleFactor = 1f;
    private float m_ScaleMultiplier = 0.05f;

    private float panX = 0f;
    private float panY = 0f;

    private PVector m_PreviousMouseCords = new PVector();

    @Override
    public void Start()
    {
        panX = width / 2;
        panY = width / 2;
    }

    @Override
    public void Update()
    {
        boolean mouseClicked = InputManager.GetInstance().IsLeftMousePressed();
        PVector mouseCords = new PVector(mouseX, mouseY);
        PVector diff = PVector.sub(m_PreviousMouseCords, mouseCords);
        m_PreviousMouseCords = mouseCords;
        
        if (mouseClicked)
            m_MoveTranslation.add(PVector.mult(diff, 1/m_ScaleFactor));

        float mouseAccel = g_InputManager.GetInstance().GetWheelAcceleration();
        

        m_ScaleFactor += mouseAccel * m_ScaleMultiplier * -1;

        
        
        translate(width/2, height/2);
        scale(m_ScaleFactor);
        translate(-m_MoveTranslation.x, -m_MoveTranslation.y);
        //translate(-panX, -panY);
        println(m_ScaleFactor);
        
    }
}