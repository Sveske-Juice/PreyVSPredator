public class BitField
{
    // Bits of an int
    int m_ByteSize = 32;

    // How many times to left shift 1 in order
    // to get m_ByteSize
    int m_IntExponent = 5; // log_2(m_ByteSize)

    // The actual bit field
    int[] bits;

    public BitField()
    {
        // Default bit field to hold 255 flags (8 * sizeof(int))
        bits = new int[8];
    }

    /// Check if the bit at the index specified is 1
    public boolean IsSet(int index)
    {
        // Calculate the length needed to query
        // the bit field for the current index.
        int b = index >> m_IntExponent;

        // If the bit field is not big enough
        // to hold a value at index.
        if (b >= bits.length)
            return false;

        int relativeFieldIdx = bits[b];

        // Create mask for the relative int in the bit field
        // where the bit at index is set.
        int mask = 1 << (index % m_ByteSize);

        return (relativeFieldIdx & mask) != 0;
    }

    /// Sets the bit at index to 1
    public void SetBit(int index)
    {
        // Calculate the length needed to query
        // the bit field for the current index.
        int b = index >> m_IntExponent;

        // If the bit field is not big enough
        // to hold a value at index.
        if (b >= bits.length)
            return;


        // Create mask for the relative int in the bit field.
        // Which bit index we want to set the bit.
        int mask = 1 << (index % m_ByteSize);

        // Apply the mask to the bit field
        bits[b] |= mask;
    }

    /// Clears the bit at the index specified
    public void ClearBit(int index)
    {
        // Calculate the length needed to query
        // the bit field for the current index.
        int b = index >> m_IntExponent;

        // If the bit field is not big enough
        // to hold a value at index.
        if (b >= bits.length)
            return;


        // Create mask for the relative int in the bit field.
        // Which bit index we want to clear.
        int mask = 1 << (index % m_ByteSize);

        // Apply the mask to the bit field
        bits[b] &= ~mask;
    }

}