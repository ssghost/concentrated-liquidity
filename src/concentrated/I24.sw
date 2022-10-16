library I24;

use core::num::*;
use std::assert::assert;

/// The 24-bit signed integer type.
/// Represented as an underlying u32 value.
/// Actual value is underlying value minus 2 ^ 24
/// Max value is 2 ^ 24 - 1, min value is - 2 ^ 24
pub struct I24 {
    underlying: u32,
}

pub trait From {
    /// Function for creating I24 from u32
    fn from(underlying: u32) -> Self;
}

impl From for I24 {
    /// Helper function to get a signed number from with an underlying
    fn from(underlying: u32) -> Self {
        Self {
            underlying,
        }
    }
}

impl core::ops::Eq for I24 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
    }
}

impl core::ops::Ord for I24 {
    fn gt(self, other: Self) -> bool {
        self.underlying > other.underlying
    }

    fn lt(self, other: Self) -> bool {
        self.underlying < other.underlying
    }
}

impl I24 {
    /// The underlying value that corresponds to zero signed value
    pub fn indent() -> u32 {
        2147483648u32
    }

    // Return the underlying value
    pub fn into(self) -> u32 {
        number.underlying
    }

    pub fn flip(self) -> u32 {
        ~self::indent() - self.underlying
    }
}

impl I24 {
    /// Initializes a new, zeroed I24.
    pub fn new() -> Self {
        Self {
            underlying: ~Self::indent(),
        }
    }

    pub fn abs(self) -> u32 {
        abs: u32 = if self.gt(I24::new()) { I24::into(self) } else {underlying: ~Self::indent() - value}
    }

    /// The smallest value that can be represented by this integer type.
    pub fn min() -> Self {
        Self {
            underlying: ~u32::min(),
        }
    }

    /// The largest value that can be represented by this type,
    pub fn max() -> Self {
        Self {
            underlying: ~u32::max(),
        }
    }

    /// The size of this type in bits.
    pub fn bits() -> u32 {
        32
    }

    /// Helper function to get a negative value of unsigned numbers
    pub fn neg_from(value: u32) -> Self {
        Self {
            underlying: ~Self::indent() - value,
        }
    }

    /// Helper function to get a positive value from unsigned number
    fn from_uint(value: u32) -> Self {
        // as the minimal value of I24 is 2147483648 (1 << 31) we should add ~I24::indent() (1 << 31) 
        let underlying: u32 = value + ~Self::indent();
        Self {
            underlying
        }
    }
}

impl core::ops::Add for I24 {
    /// Add a I24 to a I24. Panics on overflow.
    fn add(self, other: Self) -> Self {
        // subtract 1 << 31 to avoid double move
        ~Self::from(self.underlying - ~Self::indent() + other.underlying)
    }
}

impl core::ops::Subtract for I24 {
    /// Subtract a I24 from a I24. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        let mut res = ~Self::new();
        if self > other {
            // add 1 << 31 to avoid loosing the move
            res = ~Self::from(self.underlying - other.underlying + ~Self::indent());
        } else {
            // subtract from 1 << 31 as we are getting a negative value
            res = ~Self::from(~Self::indent() - (other.underlying - self.underlying));
        }
        res
    }
}

impl core::ops::Multiply for I24 {
    /// Multiply a I24 with a I24. Panics of overflow.
    fn multiply(self, other: Self) -> Self {
        let mut res = ~Self::new();
        if self.underlying >= ~Self::indent() && other.underlying >= ~Self::indent() {
            res = ~Self::from((self.underlying - ~Self::indent()) * (other.underlying -~Self::indent()) + ~Self::indent());
        } else if self.underlying < ~Self::indent() && other.underlying < ~Self::indent() {
            res = ~Self::from((~Self::indent() - self.underlying) * (~Self::indent() - other.underlying) + ~Self::indent());
        } else if self.underlying >= ~Self::indent() && other.underlying < ~Self::indent() {
            res = ~Self::from(~Self::indent() - (self.underlying - ~Self::indent()) * (~Self::indent() - other.underlying));
        } else if self.underlying < ~Self::indent() && other.underlying >= ~Self::indent() {
            res = ~Self::from(~Self::indent() - (other.underlying - ~Self::indent()) * (~Self::indent() - self.underlying));
        }
        res
    }
}

impl core::ops::Divide for I24 {
    /// Divide a I24 by a I24. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        assert(divisor != ~Self::new());
        let mut res = ~Self::new();
        if self.underlying >= ~Self::indent() && divisor.underlying > ~Self::indent() {
            res = ~Self::from((self.underlying - ~Self::indent()) / (divisor.underlying -~Self::indent()) + ~Self::indent());
        } else if self.underlying < ~Self::indent() && divisor.underlying < ~Self::indent() {
            res = ~Self::from((~Self::indent() - self.underlying) / (~Self::indent() - divisor.underlying) + ~Self::indent());
        } else if self.underlying >= ~Self::indent() && divisor.underlying < ~Self::indent() {
            res = ~Self::from(~Self::indent() - (self.underlying - ~Self::indent()) / (~Self::indent() - divisor.underlying));
        } else if self.underlying < ~Self::indent() && divisor.underlying > ~Self::indent() {
            res = ~Self::from(~Self::indent() - (~Self::indent() - self.underlying) / (divisor.underlying - ~Self::indent()));
        }
        res
    }
}

impl core::ops::