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
    bool is_contains = false;

    foreach (QVariant var, m_polygon) {
        QPolygonF p;

        foreach (QVariant point, var.toList()) {
            p << QPointF(
                    point.toList()[0].toReal() * w,
                    point.toList()[1].toReal() * h);
        }

        is_contains = p.containsPoint(QPointF(x, y), Qt::OddEvenFill);

        if(is_contains)
            break;
    }


    return is_contains;
}

