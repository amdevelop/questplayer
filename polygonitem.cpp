#include "polygonitem.h"

#include <QDebug>

PolygonItem::PolygonItem(QObject *parent) :
    QObject(parent)
{
    m_found = false;
}

bool PolygonItem::contains(qreal x, qreal y,
                           int w, int h)
{
    QPolygonF p;

    foreach (QVariant point, m_polygon) {
        p << QPointF(
                point.toList()[0].toReal() * w,
                point.toList()[1].toReal() * h);
    }

    return p.containsPoint(QPointF(x, y), Qt::OddEvenFill);
}

