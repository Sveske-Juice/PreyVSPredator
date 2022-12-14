public class Progressbar extends Component
{
    /* Members. */
    private ZVector m_Size = new ZVector(200f, 50f);
    private float m_CurrentProgress = 0f;
    private color m_BackgroundColor = color(38, 50, 74);
    private color m_ProgressColor = color(35, 200, 25);
    private ZVector m_Margin = new ZVector();

    /* Getters/Setters. */
    public void SetProgress(float value) { if (value > 1) value = 1; if (value < 0) value = 0; m_CurrentProgress = value; }
    public float GetProgress() { return m_CurrentProgress; }
    public void SetSize(ZVector size) { m_Size = size; }
    public void SetMargin(ZVector value) { m_Margin = value; }
    public void SetProgressColor(color value) { m_ProgressColor = value; }

    public Progressbar()
    {
        m_Name = "Progress bar";
    }

    public Progressbar(String name)
    {
        m_Name = name;
    }

    @Override
    public void LateUpdate()
    {
        ZVector pos = transform().GetPosition();

        // Draw background
        fill(m_BackgroundColor);
        rect(pos.x + m_Margin.x, pos.y + m_Margin.y, m_Size.x, m_Size.y);

        // Draw progress
        fill(m_ProgressColor);
        rect(pos.x + m_Margin.x, pos.y + m_Margin.y, m_Size.x * m_CurrentProgress, m_Size.y);
    }
}