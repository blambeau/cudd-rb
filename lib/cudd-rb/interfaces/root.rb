module Cudd
  module Interface
    module Root

      def root_manager?
        root_manager == self
      end

      # Returns an extension interface for a given name.
      def interface(name)
        return root_manager.interface(name) unless root_manager?
        return self if name == :Root
        interfaces[name] ||= begin
          m = Manager.new(options, native_manager, root_manager)
          m.extend Interface.const_get(name)
        end
      end

    # protected

      def with_ffi_pointer(type = :int, size = 1, &bl)
        FFI::MemoryPointer.new(type, size, &bl)
      end

    private

      def interfaces
        @interfaces ||= {}
      end

    end # module Root
  end # module Interface
end # module Cudd
