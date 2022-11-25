public class CameraHandler extends Component implements IMouseEventListener
{
    private PhysicsSystem m_PhysicsSystem;
    private Scene m_Scene;
    private float m_MinZoom = 0.005f;
    private float m_MaxZoom = 10f;    
    private float m_ScaleMultiplier = 0.05f;

    private Collider m_ChasingCollider;
    private boolean m_IsChasingColldier = false;
    private boolean m_CanSelectNewCollider = true;

    @Override
    public void Start()
    {
        m_PhysicsSystem = m_GameObject.GetBelongingToScene().GetPhysicsSystem();
        m_Scene = m_GameObject.GetBelongingToScene();

        // Register this class to get animal click events
        m_Scene.FindGameObject("Mouse Event Initiator Handler").GetComponent(MouseEventInitiator.class).AddMouseEventListener(this);
    }

    @Override
    public void Update()
    {
        float mouseAccel = g_InputManager.GetInstance().GetWheelAcceleration();
        float newScaleFactor = m_Scene.GetScaleFactor() + mouseAccel * m_ScaleMultiplier * -1;

        // Clamp scale factor to min and max allowed zoom scales
        if (newScaleFactor < m_MinZoom) newScaleFactor = m_MinZoom;
        if (newScaleFactor > m_MaxZoom) newScaleFactor = m_MaxZoom;
        m_Scene.SetScaleFactor(newScaleFactor);

        if (m_IsChasingColldier)
            ChaseCollider(m_ChasingCollider);
    }

    // Makes the camera chase a collider so its always centered
    private void ChaseCollider(Collider collider)
    {
        m_ChasingCollider = collider;
        PVector colliderPos = collider.transform().GetPosition();
        
        // Offset the collider position so it's centered on the screen
        PVector newMoveTranslation = PVector.sub(colliderPos, new PVector(width / 2f, height / 2f));

        m_Scene.SetMoveTranslation(newMoveTranslation);
    }

    public void OnColliderClick(Collider collider)
    {
        // If an animal was clicked on, then chase the animal with the camera
        if (collider == null)
            return;
        
        // Return if it's not an animal that was clicked on
        if (collider.GetGameObject() instanceof Animal)
        {
            m_IsChasingColldier = true;
            m_CanSelectNewCollider = false;
            ChaseCollider(collider);
        }
        else
        {
            m_ChasingCollider = null;
            m_IsChasingColldier = false;
        }
    }

    public void OnMouseDrag(PVector position)
    {
        if (m_CanSelectNewCollider)
        {
            m_IsChasingColldier = false;
            m_ChasingCollider = null;
        }
        PVector mouseCords = new PVector(mouseX, mouseY);
        PVector diff = PVector.sub(new PVector(pmouseX, pmouseY), mouseCords);
        m_Scene.GetMoveTranslation().add(PVector.mult(diff, 1 / m_Scene.GetScaleFactor()));
    }

    public void OnMouseRelease(PVector position)
    {
        // Mouse released, can now select new collider to focus on
        m_CanSelectNewCollider = true;
    }

    public void OnMouseClick(PVector position) { }
}