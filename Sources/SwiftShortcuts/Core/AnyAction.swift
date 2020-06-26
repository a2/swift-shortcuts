class AnyActionStorageBase {}

class AnyActionStorage<A: Action>: AnyActionStorageBase {
    var action: A

    init(_ action: A) {
        self.action = action
    }
}

public struct AnyAction: Action {
    let storage: AnyActionStorageBase

    public var body: Never { fatalError() }

    public init<Base>(_ base: Base) where Base: Action {
        if type(of: base.body) == ActionStep.self {
            self.storage = AnyActionStorage(base.body)
        } else {
            self.storage = AnyActionStorage(base)
        }
    }
}

extension AnyAction {
    init?(_fromValue value: Any) {
        // Synthesize a fake protocol conformance record to AnyActionConvertible
        let conformance = ProtocolConformanceRecord(type: type(of: value), witnessTable: 0)
        let type = unsafeBitCast(conformance, to: AnyActionConvertible.Type.self)

        guard let action = type.anyAction(from: value) else {
            return nil
        }

        self = action
    }
}

// MARK: - AnyViewConvertible

private let actionMetadata: ProtocolMetadata = {
    let module = "SwiftShortcuts"
    let name = "Action"
    let postfix = "_p"
    let mangled = "\(module.count)\(module)\(name.count)\(name)\(postfix)"
    return ProtocolMetadata(type: _typeByName(mangled)!)
}()

private protocol AnyActionConvertible {}

extension AnyActionConvertible {
    static func anyAction(from action: Any) -> AnyAction? {
        guard let witnessTable = _conformsToProtocol(Self.self, actionMetadata.protocolDescriptorVector) else {
            return nil
        }

        let conformanceRecord = ProtocolConformanceRecord(type: Self.self, witnessTable: Int(bitPattern: witnessTable))
        return withUnsafePointer(to: action as! Self) { pointer in makeAnyAction(pointer, conformanceRecord) }
    }
}

// MARK: - Protocol Runtime Information

private struct ProtocolConformanceRecord {
    let type: Any.Type
    let witnessTable: Int
}

private struct ProtocolDescriptor {}

private struct ProtocolMetadata {
    let kind: Int
    let layoutFlags: UInt32
    let numberOfProtocols: UInt32
    let protocolDescriptorVector: UnsafeMutablePointer<ProtocolDescriptor>

    init(type: Any.Type) {
        self = unsafeBitCast(type, to: UnsafeMutablePointer<Self>.self).pointee
    }
}

@_silgen_name("swift_conformsToProtocol")
private func _conformsToProtocol(
    _ type: Any.Type,
    _ protocolDescriptor: UnsafeMutablePointer<ProtocolDescriptor>
) -> UnsafeRawPointer?

@_silgen_name("_swift_shortcuts_makeAnyAction")
public func _makeAnyAction<A: Action>(from action: A) -> AnyAction {
    return AnyAction(action)
}

private typealias AnyActionFunction = @convention(thin) (UnsafeRawPointer, ProtocolConformanceRecord) -> AnyAction

import Foundation

private let makeAnyAction: AnyActionFunction = {
    let symbolName = "_swift_shortcuts_makeAnyAction"
    let handle = dlopen(nil, RTLD_GLOBAL)
    let pointer = dlsym(handle, symbolName)
    return unsafeBitCast(pointer, to: AnyActionFunction.self)
}()
