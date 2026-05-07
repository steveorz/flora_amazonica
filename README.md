# Catálogo de Flora Amazónica

Este proyecto ha sido desarrollado utilizando **Flutter** y sigue de manera estricta los principios de la **Clean Architecture** (Arquitectura Limpia). El objetivo principal de utilizar esta arquitectura es garantizar la separación de responsabilidades, logrando con ello un sistema altamente testeable, mantenible y escalable; características sumamente necesarias para documentación académica y proyectos profesionales.

## Estructura del Proyecto

El código fuente de la aplicación se encuentra organizado en diversas capas dentro del directorio `lib/`. A continuación, un detalle explicativo sobre cada un de ellas:

### 1. `core/` (Transversal)
La carpeta `core` contiene todos los recursos, clases y utilidades que son compartidos a través de todas las capas del proyecto. Es el núcleo de recursos transversales.
- **`theme/`**: Almacena las configuraciones de diseño de UI como colores, tipografías y el objeto `ThemeData` central.
- **`constants/`**: Almacena variables estáticas y globales como las URLs de un API o dimensiones estandarizadas.
- **`errors/`**: Contiene clases dedicadas al manejo de errores. En él se encuentran las definiciones formales de fallas (Failures) y excepciones (Exceptions) centralizadas.

### 2. `domain/` (Dominio)
Es la capa central y más pura de la aplicación. Aquí residen todas las reglas de negocio base. **El dominio no posee ninguna dependencia técnica hacia otras capas, frameworks (Flutter) o paquetes externos.**
- **`entities/`**: Modelos de negocio puros e independientes de los detalles de serialización. (ej. Entidad de una planta o flor).
- **`repositories_interfaces/`**: Define contratos (interfaces) que determinan qué operaciones existen para manejar datos (sin especificar cómo se implementan). Es el punto de "inversión de dependencias".
- **`usecases/`**: Contiene operaciones muy específicas iniciadas generalmente por la UI. Aplican la lógica determinando en qué orden deben ejecutarse usando los repositorios de interfaces. (Ej: `ObtenerPlantasPorRegionUseCase`).

### 3. `data/` (Datos)
Es la capa encargada del manejo externo de información. Implementa los contratos requeridos por el dominio y sirve de puente para comunicarse con bases de datos o servicios web (APIs).
- **`datasources/`**: Agrupa el código que se conecta a una fuente externa, sea remota (cliente HTTP como `http` o `dio`) o local (base de datos o memoria caché en el dispositivo como `shared_preferences`, `sqflite`).
- **`models/`**: Clases de datos destinadas especifícamente para parsear y serializar formato de respuestas (como JSON). Heredan de las `entities` del dominio.
- **`repositories/`**: Implementaciones concretas de las interfaces de `repositories_interfaces` de la capa de Dominio. Coordinan de qué DataSource se debe obtener la información y mapean los `models` hacia `entities`.

### 4. `presentation/` (Presentación)
Capa completamente dedicada a la interacción con el usuario (Interfaz gráfica, Framework visual) y manejo de estado de las vistas.
- **`screens/`**: Pantallas principales de la aplicación con la estructura general de las rutas.
- **`widgets/`**: Elementos de UI aislados y reutilizables (cuadros, botones, barras de progreso).
- **`providers/`**: Contienen los gestores de estado (controladores o ViewModels), actuando como intermediadores para leer desde los `usecases` y ofrecer el flujo de vista interactivo y reactivo a los usuarios por pantalla.

---

## Patrones y Dependencias Recomendadas

### Gestión de Estado: `flutter_riverpod`

La gestión y distribución de estado y dependencias que se utilizará a lo largo del **Catálogo de Flora Amazónica** es a través de **Riverpod**.

**Motivación Académica y de Diseño para utilizar Riverpod:**
- **Seguridad en Tiempo de Compilación:** Riverpod previene excepciones tipo `ProviderNotFoundException`, garantizando a nivel de compilador que el proveedor siempre se resolverá, una diferencia substancial a comparar con manejos antiguos dependientes del *Widget Tree*.
- **Arquitectura Unidireccional y Desacoplada:** Riverpod provee una sintaxis declarativa limpia para separar la inyección de dependencias (`data` local/remota a los `repositories`) de la capa final orientada a UI.
- **Mejor Testing y Caching:** Evita estado global residual y maneja estado asíncrono y variables de caché muy fácilmente integradas para los Future y Streams. Ideal para una arquitectura enfocada enteramente en Clean.

*Para desplegar e inicializar, utiliza `flutter run` en la raíz del proyecto.*
