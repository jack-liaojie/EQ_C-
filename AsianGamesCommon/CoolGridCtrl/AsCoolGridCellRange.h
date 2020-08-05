///////////////////////////////////////////////////////////////////////
// AsCoolCellRange.h: header file
// MFC Grid Control - interface for the CCellRange class.

#pragma once

class AX_OVRCOMMON_EXP CAsCoolGridCellID
{    
// Attributes
public:
    int m_nRow, m_nCol;

// Operations
public:
    explicit CAsCoolGridCellID(int nRow = -1, int nCol = -1) : m_nRow(nRow), m_nCol(nCol) {}

    int IsValid() const { return (m_nRow >= 0 && m_nCol >= 0); }
    int operator==(const CAsCoolGridCellID& rhs) const { return (m_nRow == rhs.m_nRow && m_nCol == rhs.m_nCol); }
    int operator!=(const CAsCoolGridCellID& rhs) const { return !operator==(rhs); }
};

class AX_OVRCOMMON_EXP CAsCoolGridCellRange
{ 
public:
    
    CAsCoolGridCellRange(int nMinRow = -1, int nMinCol = -1, int nMaxRow = -1, int nMaxCol = -1)
    {
        Set(nMinRow, nMinCol, nMaxRow, nMaxCol);
    }

    void Set(int nMinRow = -1, int nMinCol = -1, int nMaxRow = -1, int nMaxCol = -1);
    
    int  IsValid() const;
    int  InRange(int row, int col) const;
    int  InRange(const CAsCoolGridCellID& cellID) const;
    int  Count() { return (m_nMaxRow - m_nMinRow + 1) * (m_nMaxCol - m_nMinCol + 1); }
    
    CAsCoolGridCellID  GetTopLeft() const;
    CAsCoolGridCellRange  Intersect(const CAsCoolGridCellRange& rhs) const;
    
    int GetMinRow() const {return m_nMinRow;}
    void SetMinRow(int minRow) {m_nMinRow = minRow;}
    
    int GetMinCol() const {return m_nMinCol;}
    void SetMinCol(int minCol) {m_nMinCol = minCol;}
    
    int GetMaxRow() const {return m_nMaxRow;}
    void SetMaxRow(int maxRow) {m_nMaxRow = maxRow;}
    
    int GetMaxCol() const {return m_nMaxCol;}
    void SetMaxCol(int maxCol) {m_nMaxCol = maxCol;}

    int GetRowSpan() const {return m_nMaxRow - m_nMinRow + 1;}
    int GetColSpan() const {return m_nMaxCol - m_nMinCol + 1;}
    
    void operator=(const CAsCoolGridCellRange& rhs);
    int  operator==(const CAsCoolGridCellRange& rhs);
    int  operator!=(const CAsCoolGridCellRange& rhs);
    
protected:
    int m_nMinRow;
    int m_nMinCol;
    int m_nMaxRow;
    int m_nMaxCol;
};

inline void CAsCoolGridCellRange::Set(int minRow, int minCol, int maxRow, int maxCol)
{
     m_nMinRow = minRow;
     m_nMinCol = minCol;
     m_nMaxRow = maxRow;
     m_nMaxCol = maxCol;
}

inline void CAsCoolGridCellRange::operator=(const CAsCoolGridCellRange& rhs)
{
    if (this != &rhs) Set(rhs.m_nMinRow, rhs.m_nMinCol, rhs.m_nMaxRow, rhs.m_nMaxCol);
}

inline int CAsCoolGridCellRange::operator==(const CAsCoolGridCellRange& rhs)
{
     return ((m_nMinRow == rhs.m_nMinRow) && (m_nMinCol == rhs.m_nMinCol) &&
             (m_nMaxRow == rhs.m_nMaxRow) && (m_nMaxCol == rhs.m_nMaxCol));
}

inline int CAsCoolGridCellRange::operator!=(const CAsCoolGridCellRange& rhs)
{
     return !operator==(rhs);
}

inline int CAsCoolGridCellRange::IsValid() const
{
     return (m_nMinRow >= 0 && m_nMinCol >= 0 && m_nMaxRow >= 0 && m_nMaxCol >= 0 &&
             m_nMinRow <= m_nMaxRow && m_nMinCol <= m_nMaxCol);
}

inline int CAsCoolGridCellRange::InRange(int row, int col) const
{
     return (row >= m_nMinRow && row <= m_nMaxRow && col >= m_nMinCol && col <= m_nMaxCol);
}

inline int CAsCoolGridCellRange::InRange(const CAsCoolGridCellID& cellID) const
{
     return InRange(cellID.m_nRow, cellID.m_nCol);
}

inline CAsCoolGridCellID CAsCoolGridCellRange::GetTopLeft() const
{
     return CAsCoolGridCellID(m_nMinRow, m_nMinCol);
}

inline CAsCoolGridCellRange CAsCoolGridCellRange::Intersect(const CAsCoolGridCellRange& rhs) const
{
     return CAsCoolGridCellRange(max(m_nMinRow,rhs.m_nMinRow), max(m_nMinCol,rhs.m_nMinCol),
                       min(m_nMaxRow,rhs.m_nMaxRow), min(m_nMaxCol,rhs.m_nMaxCol));
}
