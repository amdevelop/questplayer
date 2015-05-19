#ifndef POLYGONITEM_H
#define POLYGONITEM_H

#include <QObject>

#include <QtDeclarative>

class PolygonItem : public QObject
{
    Q_OBJECT

    QVariantList m_polygon;
    bool m_found;

public:
    explicit PolygonItem(QObject *parent = 0);
    
    Q_PROPERTY(QVariantList polygon READ polygon WRITE setPolygon USER true)
    Q_PROPERTY(bool found READ found WRITE setFound USER true)

    void setPolygon(QVariantList p)
    {
        m_polygon = p;
    }

    QVariantList polygon() const
    {
        return m_polygon;
    }

    void setFound(bool p)
    {
        m_found = p;
    }

    bool found() const
    {
        return m_found;
    }


    Q_INVOKABLE bool contains(qreal x, qreal y,
                              int w, int h);
};


#endif // POLYGONITEM_H
