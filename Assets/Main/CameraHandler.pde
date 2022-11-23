public class CameraHandler extends Component
{
    private PhysicsSystem m_PhysicsSystem;
    private Scene m_Scene;
    private float m_MinZoom = 0.05f;
    private float m_MaxZoom = 10f;    
    private float m_ScaleMultiplier = 0.05f;
    private PVector m_PreviousMouseCords = new PVector();

    @Override
    public void Start()
    {
        m_PhysicsSystem = m_GameObject.GetBelongingToScene().GetPhysicsSystem();
        m_Scene = m_GameObject.GetBelongingToScene();        
    }

    @Override
    public void Update()
    {
        boolean mouseClicked = InputManager.GetInstance().IsLeftMousePressed();
        PVector mouseCords = new PVector(mouseX, mouseY);
        PVector diff = PVector.sub(m_PreviousMouseCords, mouseCords);
        m_PreviousMouseCords = mouseCords;

        float mouseAccel = g_InputManager.GetInstance().GetWheelAcceleration();
        
        float newScaleFactor = m_Scene.GetScaleFactor() + mouseAccel * m_ScaleMultiplier * -1;

        // Clamp scale factor to min and max allowed zoom scales
        if (newScaleFactor < m_MinZoom) newScaleFactor = m_MinZoom;
        if (newScaleFactor > m_MaxZoom) newScaleFactor = m_MaxZoom;
        m_Scene.SetScaleFactor(newScaleFactor);

        if (mouseClicked)
        {
            // If an animal was clicked on, then chase the animal with the camera
            Collider hitCollider = m_PhysicsSystem.PointOverlap(mouseCords);
            if (hitCollider != null)
                println("HIT!");

            m_Scene.GetMoveTranslation().add(PVector.mult(diff, 1 / m_Scene.GetScaleFactor()));
        }
            
    }
}