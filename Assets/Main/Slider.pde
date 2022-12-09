public class SliderObject extends UIElement
{
    public SliderObject()
    {
        super("Slider Object");
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        // Add Slider behaviour script
        AddComponent(new Slider());
    }

    @Override
    public ArrayList<GameObject> CreateChildren()
    {
        ArrayList<GameObject> out = new ArrayList<GameObject>(1);
        
        // Create knob as a child object
        out.add(new KnobObject());

        return out;
    }
}

public class Slider extends Component
{
    /* Members. */
    private float m_MaxValue = 100f; // The max value of the slider
    private float m_SliderLength = 400f;
    private float m_MinValue = 10f; // The minimum value of the slider
    private float m_CurrentValue = 0f;
    private float m_Progress = 0f; // Holds the acual progress value of the slider (a linear interpolated value between min and max)
    private color m_SliderColor = color(40, 60, 110);
    private ZVector m_Margin = new ZVector();
    private float m_Thickness = 8f; // Slider line thickness/weight
    private Knob m_KnobBehaviour;
    private boolean m_ShowMinText = true; // Should show text field of the minimum value
    private boolean m_ShowMaxText = true; // Should show text field of the max value

    /* Getters/Setters. */
    public void SetMaxValue(float value) { m_MaxValue = value; }
    public float GetMaxValue() { return m_MaxValue; }
    public void SetMinValue(float value) { m_MinValue = value; }
    public float GetMinValue() { return m_MinValue; }
    
    public void SetSliderColor(color value) { m_SliderColor = value; }
    public void SetMargin(ZVector value) { m_Margin = value; }
    public void SetThickness(float value) { m_Thickness = value; }
    public float GetProgress() { return m_Progress; }
    public void SetShowProgressText(boolean value) { m_KnobBehaviour.SetShowProgressText(value); /* Forward the setter to the knob behaviour. */ }
    public void SetProgress(float progress)
    {
        // println("setting progress to: " + progress);
        // println("max: " + m_MaxValue);
        // println("len: " + m_SliderLength);

        // TODO FIXME doesn't work propely, too lazy to fixx
        float v = (progress / m_MaxValue) * m_SliderLength;
        
        m_KnobBehaviour.transform().SetPosition(new ZVector(v, 0f));
    }

    
    @Override
    public void Start()
    {
        // Get reference to the knob behaviour class
        m_KnobBehaviour = transform().GetChild(0).GetGameObject().GetComponent(Knob.class);

        // setup pos value
        MoveKnob(new ZVector(0f));
    }

    @Override
    public void LateUpdate()
    {
        ZVector pos = ZVector.add(transform().GetPosition(), m_Margin);

        // Draw slider line
        stroke(m_SliderColor);
        strokeWeight(m_Thickness);
        line(pos.x, pos.y, pos.x + m_SliderLength, pos.y);
        strokeWeight(1f); // Default
        stroke(0); // Default

        // Draw texts
        fill(255);
        textSize(14);
        if (m_ShowMinText)
        {
            text(m_MinValue + "", pos.x, pos.y + 10f);
        }

        if (m_ShowMaxText)
        {
            text(m_MaxValue + "", pos.x + m_SliderLength, pos.y + 10f);
        }
    }

    /*
     * Handles moving the knob in the movement specified by 'movement'.
    */
    public void MoveKnob(ZVector movement)
    {
        // New position of knob without any clamping
        ZVector newKnobPos = ZVector.add(m_KnobBehaviour.transform().GetPosition(), movement);

        // Clamp the new position to be inside the slider
        ZVector clampedKnobPos = ClampToSlider(newKnobPos);

        // Apply new position
        m_KnobBehaviour.transform().SetPosition(clampedKnobPos);

        // Update slider position value
        m_CurrentValue = clampedKnobPos.x - transform().GetPosition().x - m_Margin.x;

        // Update slider progress value
        float t = m_CurrentValue / m_SliderLength; // Get percentage

        // Linear interpolate along the min and max values by its progress percentage, t
        m_Progress = m_MinValue + t * (m_MaxValue - m_MinValue);
    }

    /*
     * Clamps a vector to the be on the slider.
    */
    private ZVector ClampToSlider(ZVector vec)
    {
        // TODO move to ZVector.java
        ZVector sliderPos = ZVector.add(transform().GetPosition(), m_Margin);

        ZVector clamped = vec.copy();
        clamped.x = Clamp(vec.x, sliderPos.x, sliderPos.x + m_SliderLength);
        clamped.y = Clamp(vec.y, sliderPos.y, sliderPos.y);
        return clamped;
    }

    // TODO move somewhere else
    private float Clamp(float value, float min, float max)
    {
        if (value > max) return max;
        if (value < min) return min;

        return value;
    }
}

public class KnobObject extends UIElement
{
    public KnobObject()
    {
        super("Slider Knob Object");
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        // Add knob behaviour script
        AddComponent(new Knob());

        // Add collider for the knob
        AddComponent(new CircleCollider("Slider Knob Collider", 30f));
    }
}

public class Knob extends Component implements IMouseEventListener
{
    /* Members. */
    private Slider m_SliderBehaviour;
    private Collider m_KnobCollider;
    private float m_KnobRadius = 35f;
    private color m_KnobColor = color(0, 255, 0);
    private boolean m_KnobClicked = false;
    private boolean m_MouseDrag = false;
    private ZVector m_MouseDiff = new ZVector();
    private color m_CurrentTextColor = color(0, 0, 0);
    private int m_CurrentTextSize = 14;
    private boolean m_ShowCurrentText = true; // Should show text field of the current value inside the knob

    /* Getters/Setters. */
    public void SetKnobRadius(float value) { m_KnobRadius = value; }
    public void SetKnobColor(color value) { m_KnobColor = value; }
    public void SetShowProgressText(boolean value) { m_ShowCurrentText = value; }

    @Override
    public void Start()
    {
        m_SliderBehaviour = transform().GetParent().GetGameObject().GetComponent(Slider.class);
        m_KnobCollider = m_GameObject.GetComponent(Collider.class);
        m_KnobCollider.SetTrigger(true);

        // Register this class to get mouse events
        m_GameObject.GetBelongingToScene().FindGameObject("Mouse Event Initiator Handler").GetComponent(MouseEventInitiator.class).AddMouseEventListener(this);
    }

    @Override
    public void LateUpdate()
    {
        ZVector pos = transform().GetPosition();

        // If the mouse is being dragged and the knob collider is being clicked/held, then move the knob
        if (m_MouseDrag && m_KnobClicked)
            m_SliderBehaviour.MoveKnob(m_MouseDiff);
        else // If not don't move
        {
            m_MouseDiff = new ZVector();
            /* NOTE:
             * This line is here since transform and nested childrens sync positions is not working properly
             * MoveKnob() will do so it's position stays.
            */
            m_SliderBehaviour.MoveKnob(m_MouseDiff);
        }

        // Draw slider knob
        fill(m_KnobColor);
        circle(pos.x, pos.y, m_KnobRadius);

        // Draw progress value inside knob
        if (m_ShowCurrentText)
        {
            fill(m_CurrentTextColor);
            textAlign(CENTER, CENTER);
            textSize(m_CurrentTextSize);
            text(round(m_SliderBehaviour.GetProgress()), pos.x, pos.y);
        }
    }

    @Override
    public void OnMouseDrag(ZVector position)
    {
        // Calculate the delta mouse position used for the movement applied to the knob
        m_MouseDiff = ZVector.sub(position, new ZVector(pmouseX, pmouseY));

        m_MouseDrag = true;
    }

    @Override
    public void OnColliderClick(Collider collider)
    {
        // Check if the knob was clicked on
        if (m_KnobCollider.GetId() == collider.GetId())
        {
            m_KnobClicked = true;
        }
    }

    @Override
    public void OnMouseClick(ZVector position) { }

    @Override
    public void OnMouseRelease(ZVector position)
    {
        // Reset flags
        m_MouseDrag = false;
        m_KnobClicked = false;
    }
}