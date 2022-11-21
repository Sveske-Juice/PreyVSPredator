public class InputManager
{
    // Singleton pattern to access everywhere
    private static InputManager m_Instance;

    private boolean m_LeftMouseBtn = false;
    private boolean m_RightMouseBtn = false;
    private float m_WheelAcceleration = 0f;
    private boolean m_WheelChanged = false;

    private boolean m_MouseBeingDragged = false;

    public boolean IsLeftMousePressed() { return m_LeftMouseBtn;  }
    public void SetLeftMousePressed(boolean value) { m_LeftMouseBtn = value; }
    public boolean IsRightMousePressed() { return m_RightMouseBtn; }
    public void SetRightMousePressed(boolean value) { m_RightMouseBtn = value; }
    public float GetWheelAcceleration() { return m_WheelAcceleration; }
    public void SetWheelAcceleration(float accel) { m_WheelAcceleration = accel; m_WheelChanged = true;}
    public boolean IsMouseBeingDragged() { return m_MouseBeingDragged; }
    public void SetMouseBeingDragged(boolean value) { m_MouseBeingDragged = value; }

    
    private BitField m_KeyMap = new BitField();

    public InputManager()
    {
        m_Instance = this;
    }

    public static InputManager GetInstance()
    {
        return m_Instance;
    }

    // Sets the the key to on in the keymap
    public void RegisterKey(char key)
    {
        m_KeyMap.SetBit((int) key);
    }

    // Clears the key from the key map
    public void UnregisterKey(char key)
    {
        m_KeyMap.ClearBit((int) key);
    }

    // Return true if the key is being pressed
    public boolean GetKey(char key)
    {
        return m_KeyMap.IsSet((int) key);
    }

    // Return true if the key is being pressed
    public boolean GetKey(int code)
    {
        return m_KeyMap.IsSet(code);
    }

    public String GetMap()
    {
        String out = "";
        for (int i = 0; i < 255; i++)
        {
            out += (m_KeyMap.IsSet(i) ? "1" : "0") + " ";
        }
        return out;
    }

    public void Update()
    {
        if (m_WheelChanged)
        {
            m_WheelChanged = false;
            m_WheelAcceleration = 0f;
        }
    }
}