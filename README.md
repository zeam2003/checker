# Checker App

Una aplicación Flutter para gestión y verificación de diagnósticos.

## 🎯 Descripción General del Proyecto

Checker es una herramienta profesional de diagnóstico diseñada para optimizar el proceso de verificación y seguimiento del estado de dispositivos. Proporciona una interfaz intuitiva para gestionar y monitorear varios aspectos diagnósticos de los dispositivos.

## 🏆 Milestone 1: UI Core & Funcionalidad Básica
### Características Completadas
- **Componente Header**
  - Barra de navegación profesional con logo
  - Sistema de notificaciones de usuario
  - Punto de acceso al perfil

- **Panel de Información**
  - Seguimiento de fecha de creación
  - Contador de chequeos
  - Gestión de tickets
  - Visualización de información del usuario

- **Rastreador de Progreso Interactivo**
  - Progresión visual por pasos
  - Indicadores de estado (Bueno, Regular, Malo)
  - Actualizaciones en tiempo real
  - Retroalimentación con códigos de color

- **Tarjetas de Diagnóstico**
  - Diagnósticos específicos por componente
  - Sistema de selección de estado
  - Campo de observaciones
  - Capacidad de modificación de estado

## 🏆 Milestone 2: Autenticación y Persistencia
### Características Implementadas
- **Sistema de Autenticación**
  - Login con persistencia de sesión
  - Manejo de tokens JWT
  - Protección de rutas
  - Cierre de sesión seguro

- **Gestión de Estado**
  - Implementación de Riverpod
  - Estado global de la aplicación
  - Manejo asíncrono de datos
  - Persistencia con SharedPreferences

- **Navegación Segura**
  - Implementación de go_router
  - Redirecciones basadas en autenticación
  - Manejo de rutas protegidas
  - Breadcrumbs para navegación

## 🛠 Stack Tecnológico
- Flutter
- Riverpod (Gestión de Estado)
- go_router (Navegación)
- SharedPreferences (Almacenamiento Local)
- Google Fonts
- Font Awesome Icons
- Dio (Cliente HTTP)

## 📱 Características Actuales
- Seguimiento de diagnósticos de dispositivos
- Sistema de gestión de estados
- Visualización de progreso
- Tarjetas de diagnóstico interactivas
- Actualizaciones en tiempo real
- Persistencia de sesión de usuario
- Protección de rutas basada en autenticación

## 🔜 Próximos Pasos
- Implementar sincronización offline
- Añadir sistema de reportes detallados
- Desarrollar seguimiento histórico
- Agregar funcionalidad de exportación
- Implementar notificaciones push

## 📝 Notas
Este proyecto establece una base sólida con autenticación robusta y persistencia de datos, preparando el camino para futuras fases de desarrollo con características más avanzadas.
