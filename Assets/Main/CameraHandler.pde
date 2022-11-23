public class CameraHandler extends Component
{
    private PhysicsSystem m_PhysicsSystem;
    private Scene m_Scene;
    private float m_MinZoom = 0.05f;
    private float m_MaxZoom = 10f;    
    private float m_ScaleMultiplier = 0.05f;
    private PVector m_PreviousMouseCords = new PVector();

    private Collider m_ChasingCollider;
    private boolean m_IsChasingColldier = false;
    private boolean m_MouseClickedLastFrame = false;
    private boolean m_CanSelectNewCollider = true;

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
            {
                if (hitCollider == m_ChasingCollider)
                    return;
                
                m_IsChasingColldier = true;
                m_CanSelectNewCollider = false;
                ChaseCollider(hitCollider);
            }
            else
            {
                // If the mouse was released between selecting a new collider to chase
                // and the mouse was clicked somewhere else, then stop chasing
                if (m_CanSelectNewCollider) 
                {
                    m_ChasingCollider = null;
                    m_IsChasingColldier = false;
                }
            }

        }

        if (mouseClicked && m_MouseClickedLastFrame) // Dragging mouse
            m_Scene.GetMoveTranslation().add(PVector.mult(diff, 1 / m_Scene.GetScaleFactor()));
        
        if (!mouseClicked && m_MouseClickedLastFrame) // Mouse button released
            m_CanSelectNewCollider = true;

        if (m_IsChasingColldier)
            ChaseCollider(m_ChasingCollider);

        m_MouseClickedLastFrame = mouseClicked;
            
    }

    // Makes the camera chase a collider so its always centered
    private void ChaseCollider(Collider collider)
    {
        m_ChasingCollider = collider;
        PVector colliderPos = collider.transform().Position;
        
        // Offset the collider position so it's centered on the screen
        PVector newMoveTranslation = PVector.sub(colliderPos, new PVector(width / 2f, height / 2f));

        m_Scene.SetMoveTranslation(newMoveTranslation);
    }
}